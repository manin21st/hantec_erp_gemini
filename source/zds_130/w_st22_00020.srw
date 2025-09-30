$PBExportHeader$w_st22_00020.srw
$PBExportComments$계측기기 마스타
forward
global type w_st22_00020 from w_inherite
end type
type st_2 from statictext within w_st22_00020
end type
type p_2 from picture within w_st22_00020
end type
type pb_1 from u_pb_cal within w_st22_00020
end type
type pb_2 from u_pb_cal within w_st22_00020
end type
type pb_3 from u_pb_cal within w_st22_00020
end type
type p_3 from uo_picture within w_st22_00020
end type
type p_1 from uo_picture within w_st22_00020
end type
type pb_4 from u_pb_cal within w_st22_00020
end type
type pb_5 from u_pb_cal within w_st22_00020
end type
type rr_2 from roundrectangle within w_st22_00020
end type
type rr_1 from roundrectangle within w_st22_00020
end type
end forward

global type w_st22_00020 from w_inherite
integer width = 5650
integer height = 2420
string title = "계측기기 마스타"
st_2 st_2
p_2 p_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
p_3 p_3
p_1 p_1
pb_4 pb_4
pb_5 pb_5
rr_2 rr_2
rr_1 rr_1
end type
global w_st22_00020 w_st22_00020

type variables
blob	iblobBMP
end variables

forward prototypes
public function integer wf_load_image ()
public function integer wf_required_chk ()
public subroutine wf_initial ()
public function integer wf_save_image ()
public subroutine wf_upload ()
public subroutine wf_copy ()
end prototypes

public function integer wf_load_image ();string	sMchNo
int 		iCnt
blob		lblobBMP

p_2.Visible = False

sMchNo = dw_insert.getitemstring(1,"mchno")
///////////////////////////////////////////////////////////////////////////////////////////////
Select count(*) Into :iCnt From lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo   ;

If iCnt = 0 Then Return -1

Selectblob image into :lblobBMP from lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;

If sqlca.sqlcode = -1 Then
	MessageBox("SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

// Instance 변수에 보관
iblobBMP = lblobBMP
If p_2.SetPicture(iblobBMP) = 1 Then
	p_2.Visible = True
End if

Return 1
end function

public function integer wf_required_chk ();long		lgiilsu
string	smchno, smchnm, syongdo, sgikwan, smaker, sgrpcode

smchno = trim(dw_insert.getitemstring(1,'mchno'))
if isnull(smchno) or smchno = "" then
	f_message_chk(30,'[관리번호]')
	dw_insert.setcolumn('mchno')
	dw_insert.setfocus()
	return -1
end if

smchnm = trim(dw_insert.getitemstring(1,'mchnam'))
if isnull(smchnm) or smchnm = "" then
	f_message_chk(30,'[기기명칭]')
	dw_insert.setcolumn('mchnam')
	dw_insert.setfocus()
	return -1
end if
//2006.01.21 용도는 임시보류 일단 필수에서 제외. QC박인분요구
/*
syongdo = trim(dw_insert.getitemstring(1,'yongdo'))
if isnull(syongdo) or syongdo = "" then
	f_message_chk(30,'[용도]')
	dw_insert.setcolumn('yongdo')
	dw_insert.setfocus()
	return -1
end if
*/
//2006.01.16 필수키제외 송병호과장지시
//sgikwan = trim(dw_insert.getitemstring(1,'gikwan'))
//if isnull(sgikwan) or sgikwan = "" then
//	f_message_chk(30,'[검사장소]')
//	dw_insert.setcolumn('gikwan')
//	dw_insert.setfocus()
//	return -1
//end if

smaker = trim(dw_insert.getitemstring(1,'maker'))
if isnull(smaker) or smaker = "" then
	f_message_chk(30,'[제작회사명]')
	dw_insert.setcolumn('maker')
	dw_insert.setfocus()
	return -1
end if

sgrpcode = trim(dw_insert.getitemstring(1,'grpcode'))
if isnull(sgrpcode) or sgrpcode = "" then
	f_message_chk(30,'[계측기기 그룹]')
	dw_insert.setcolumn('grpcode')
	dw_insert.setfocus()
	return -1
end if

lgiilsu = dw_insert.getitemnumber(1,'giilsu')
if isnull(lgiilsu) or lgiilsu <= 0 then
	f_message_chk(30,'[교정주기]')
	dw_insert.setcolumn('giilsu')
	dw_insert.setfocus()
	return -1
end if

dw_insert.setitem(1,'sabu',gs_sabu)

return 1
end function

public subroutine wf_initial ();dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)

dw_insert.setitem(1,'lasdat',f_today())

dw_insert.setcolumn( 'mchno')
dw_insert.setfocus( )

dw_insert.setredraw(true)

p_2.visible = false
p_2.picturename = ''
//p_2.visible = true

ib_any_typing = false
end subroutine

public function integer wf_save_image ();String	sMchNo
integer	iCnt

If Not p_2.Visible Then Return 0
if isnull(iblobBMP) then return 0

///////////////////////////////////////////////////////////////////////////////////////////////
smchno = trim(dw_insert.getitemstring(1,'mchno'))

Select count(*) Into :iCnt From lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo   ;

If iCnt = 0 Then
	Insert Into lw_mchmes_image
	( sabu,				mchgb,		mchno )
	Values
	( :gs_sabu,			'2',			:smchno ) ;
	
	if sqlca.sqlcode <> 0 then
		rollback ;
		messagebox("이미지 저장실패", "관리번호 이미지 저장 실패!!!")
		return 0
	end if
End If
///////////////////////////////////////////////////////////////////////////////////////////////


sqlca.autocommit = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////
// 계측기 이미지 저장
Updateblob lw_mchmes_image
   Set image = :iblobBMP
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;

If SQLCA.SQLCode = -1 Then
	MessageBox("Save Image SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

Commit;

sqlca.autocommit = FALSE

Return 1
end function

public subroutine wf_upload ();String	sPath, sFileName
Int 		iRtn, iFHandle, i
Long		lFileLen, lLoops, lReadBytes
Blob		blobTot, blobA


iRtn = GetFileOpenName("이미지 파일지정",sPath,sFileName,"IMAGE","Bitmap Files (*.BMP),*.BMP,JPEG Files (*.JPG),*.JPG")
If iRtn = 1 Then
	lFileLen = FileLength(sPath)
	iFHandle = FileOpen(sPath, StreamMode!, Read!, LockRead!)

	if iFHandle <> -1 then
		////////////////////////////////////////////////////////////////////////////////////////
		// 파일size가 FileRead 한도를 초과하는 경우 처리
		if lFileLen > 32765 then
			if Mod(lFileLen, 32765) = 0 then
				lLoops = lFileLen/32765
			else
				lLoops = (lFileLen/32765) + 1
			end if		
		else
			lLoops = 1		
		end if


		////////////////////////////////////////////////////////////////////////////////////////
		FOR i = 1 to lLoops
			lReadBytes = FileRead(iFHandle, blobA)
			blobTot    = blobTot + blobA
		NEXT

		FileClose(iFHandle)
		
		iblobBMP = blobTot
		p_2.SetPicture(blobTot)
		p_2.Visible = True
	end if
else
	p_2.Visible = False
	Return
End If
end subroutine

public subroutine wf_copy ();string	snull
integer	irtn

if dw_insert.getitemstring(1,'create_flag') = 'Y' then
	messagebox('확인','복사할 계측기기 정보를 불러온 후 처리하세요!!!')
	return
end if

if messagebox('확인','현재 조회된 계측기기 정보를 복사합니다.',question!,yesno!,1) = 2 then
	return
end if

irtn = dw_insert.setitemstatus(1, 0, Primary!, New!)
if irtn = -1 or isnull(irtn) then
	messagebox('확인','복사실패!!! 다시 조회후 처리하세요!!!')
	p_can.triggerevent(clicked!)
	return
end if

setnull(snull)

//2006.01.16자동부여코드 맞는지 확인
dw_insert.setitem(1,'mchno','')//dw_insert.getitemstring(1,'grpcode')+'')
dw_insert.setitem(1,'create_flag','Y')
dw_insert.setcolumn('mchno')
dw_insert.setfocus()

p_2.picturename = ''
p_2.picturename = ''

setnull(iblobBMP)
end subroutine

on w_st22_00020.create
int iCurrent
call super::create
this.st_2=create st_2
this.p_2=create p_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.p_3=create p_3
this.p_1=create p_1
this.pb_4=create pb_4
this.pb_5=create pb_5
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.p_3
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.pb_4
this.Control[iCurrent+9]=this.pb_5
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_1
end on

on w_st22_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.p_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.p_3)
destroy(this.p_1)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_st22_00020
integer x = 78
integer y = 316
integer width = 2880
integer height = 1808
integer taborder = 20
string dataobject = "d_ST22_00020_a"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;call super::itemchanged;long		ljugi
string	scode, sname, snull, splace, sspec, sjung
string	smchno, smchnam, sline, slinename
String   sdept, sdeptnm, SGRNAME

setnull(snull)

If this.AcceptText() = -1 Then Return 1

if this.getcolumnname() = 'mchno' then
	scode = this.gettext()
	
	p_inq.postevent(clicked!)

//elseif this.getcolumnname() = 'mngman' then
//	scode = this.gettext()
//	
//	if isnull(scode) or scode = '' then
//		this.setitem(1,'empname',snull)
//		return
//	end if
//	
//	select a.empname, b.deptcode, b.deptname 
//	  into :sname, :sdept, :sdeptnm
//	  from p1_master a,
//	       p0_dept b  
//	 where a.empno = :scode 
//	   and a.deptcode = b.deptcode ;
//	if sqlca.sqlcode = 0 then
//		this.setitem(1,'empname',sname)
//		this.setitem(1,'lastoutdept',sdept)
//		this.setitem(1,'dptname',sdeptnm)
//	else
//		this.setitem(1,'empno',snull)
//		this.setitem(1,'empname',snull)
//		this.setitem(1,'lastoutdept',snull)
//		this.setitem(1,'dptname',snull)
//		return 1
//	end if
	
//	SELECT B.MCHNO, B.MCHNAM, B.WKCTR, C.WCDSC
//	  INTO :smchno, :smchnam, :sline, :slinename
//	  FROM ROUTNG_RESOURCE A, MCHMST B, WRKCTR C
//	 WHERE A.GUBUN = 'P'
//	   AND A.RCODE = :scode
//		AND A.ITNBR = B.WRK_GRPCOD
//		AND B.WKCTR = C.WKCTR
//		AND ROWNUM = 1 ;
//	if sqlca.sqlcode = 0 then
//		this.setitem(1,'mchcode',smchno)
//		this.setitem(1,'mchname',smchnam)
//		this.setitem(1,'linecode',sline)
//		this.setitem(1,'linename',slinename)
//	end if		
	
//elseif this.getcolumnname() = 'lastoutdept' then
//	scode = this.gettext()
//	
//	if isnull(scode) or scode = '' then
//		this.setitem(1,'dptname',snull)
//		return
//	end if
//	
//	select deptname into :sname from p0_dept
//	 where deptcode = :scode ;
//	if sqlca.sqlcode = 0 then
//		this.setitem(1,'dptname',sname)
//	else
//		this.setitem(1,'lastoutdept',snull)
//		this.setitem(1,'dptname',snull)
//		return 1
//	end if

elseif this.getcolumnname() = 'grpcode' then
	scode = this.gettext()
	
	if isnull(scode) or scode = '' then
		this.setitem(1,'mchnam',snull)
		this.setitem(1,'giilsu',0)
//		this.setitem(1,'gikwan',snull)
		this.setitem(1,'spec',snull)
		this.setitem(1,'jungdo',snull)
		This.SetItem(1,'grname', snull)
		this.setitem(1,'gbn',snull)
		return
	End IF
	
	select grname, grjugi, grgmpl, grsize, grjung, GRNAME
	  into :sname, :ljugi, :splace, :sspec, :sjung, :SGRNAME
	  from lw_mesgrp
	 where sabu = :gs_sabu and grgrco = :scode ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,'mchnam',sname)
		this.setitem(1,'giilsu',ljugi)
//		this.setitem(1,'gikwan',splace)
		this.setitem(1,'spec',sspec)
		this.setitem(1,'jungdo',sjung)
		This.SetItem(1, 'grname', sgrname)
		this.setitem(1,'gbn',left(scode,1))
	else
		this.setitem(1,'mchnam',snull)
		this.setitem(1,'giilsu',0)
//		this.setitem(1,'gikwan',snull)
		this.setitem(1,'spec',snull)
		this.setitem(1,'jungdo',snull)
		This.SetItem(1,'grname', snull)
		this.setitem(1,'gbn',snull)
		return 1
	end if
end if


if this.getcolumnname() = 'linecode' then
	scode = this.gettext()
	
	If IsNull(scode) Or scode = '' Then
		this.setitem(1,'linename',snull)
		return
	End If
	
	select wcdsc into :sname from wrkctr
	 where wkctr = :scode ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,'linename',sname)
	else
		this.setitem(1,'linecode',snull)
		this.setitem(1,'linename',snull)
		return 1
	end if
	
elseif this.getcolumnname() = 'mchcode' then
	scode = this.gettext()
	
	If IsNull(scode) Or scode = '' Then
		this.setitem(1,'mchname',snull)
		return
	End If
	
	select mchnam into :sname from mchmst
	 where mchno = :scode ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,'mchname',sname)
	else
		this.setitem(1,'mchcode',snull)
		this.setitem(1,'mchname',snull)
		return 1
	end if
ElseIf this.getcolumnname() = 'gikwan' Then
	scode = Trim(this.gettext())
	
	If IsNull(scode) Or scode = '' Then
		this.object.gikwan_nm[row] = snull
		ReTurn
	End If
	
	SELECT	CVNAS
	INTO		:sname
	FROM		VNDMST
	WHERE		CVCOD = :scode;
	
	If sqlca.sqlcode <> 0 Then
		this.object.gikwan[row] = snull
		this.object.gikwan_nm[row] = snull
		Messagebox("확인","등록된 거래처 혹은 부서가 아닙니다.",Information!)
		Return 1
	End If
	
	this.object.gikwan_nm[row] = sname
ElseIf this.GetColumnName() = 'lastoutdept' Then
	scode = Trim(this.GetText())
	
	If IsNull(scode) Or scode = '' Then
		this.object.dptname[row] = snull
		ReTurn
	End If
	
	SELECT	CVNAS
	INTO		:sname
	FROM		VNDMST
	WHERE		CVCOD = :scode
	AND		CVGU = '4';
	
	If sqlca.sqlcode <> 0 Then
		this.object.lastoutdept[row] = snull
		this.object.dptname[row] = snull
		Messagebox("확인","등록된 부서가 아닙니다.",Information!)
		Return 1
	End If
	
	this.object.dptname[row] = sname
end if
end event

event dw_insert::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose	Case 	this.getcolumnname() 
	Case 'mchno' 
		open(w_st22_00020_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'mchno',gs_code)
		p_inq.postevent(clicked!)
//	Case 	'mngman' 
//		open(w_sawon_popup)
//		if isnull(gs_code) or gs_code = '' then return
//		
//		this.setitem(1,'mngman',gs_code)
//		this.triggerevent(itemchanged!)
	Case	'lastoutdept' 
		open(w_vndmst_4_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'lastoutdept',gs_code)
//		this.triggerevent(itemchanged!)
		this.Trigger Event itemchanged(row,dwo,gs_code)
//	Case 	'buyitnbr' 
//		open(w_itemas_popup)
//		if isnull(gs_code) or gs_code = '' then return
//		
//		this.setitem(1,'buyitnbr',gs_code)
	Case 'grpcode' //계측기기그룹
		open(w_st22_00010_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'grpcode',gs_code)
//		this.triggerevent(itemchanged!)
		this.Trigger Event itemchanged(row,dwo,gs_code)
	Case 	'linecode'
		open(w_workplace_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'linecode',gs_code)
//		this.triggerevent(itemchanged!)
		this.Trigger Event itemchanged(row,dwo,gs_code)
	Case 	'mchcode'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'mchcode',gs_code)
		this.triggerevent(itemchanged!)

	Case "kfcod2"	 	//고정자산 일련번호.
		gs_code = this.getitemstring(1, 'kfcod1')
		open(w_kfaa02b)
		If IsNull(gs_code) Or gs_code = '' Then Return

		SetItem(1,'kfcod1', gs_code)
		SetItem(1,'kfcod2', dec(gs_codename))
	Case 'gikwan' //검사장소--거래처코드 혹은 부서코드로 대
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'gikwan',gs_code)
	
		this.Trigger Event itemchanged(row,dwo,gs_code)
end Choose

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;if dwo.name <> 'mchno' then 
	if this.getitemstring(row,'create_flag') = 'N' then return
	p_inq.postevent(clicked!)
end if
end event

type p_delrow from w_inherite`p_delrow within w_st22_00020
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_st22_00020
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_st22_00020
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_st22_00020
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_st22_00020
integer x = 4425
end type

type p_can from w_inherite`p_can within w_st22_00020
integer x = 4251
end type

event p_can::clicked;string	smchno

smchno = trim(dw_insert.getitemstring(1,'mchno'))
wf_initial()

if isnull(smchno) or smchno = '' then
else
//	dw_insert.setitem(1,'mchno',smchno)
end if
end event

type p_print from w_inherite`p_print within w_st22_00020
boolean visible = false
integer x = 4713
integer y = 340
end type

type p_inq from w_inherite`p_inq within w_st22_00020
integer x = 3730
end type

event p_inq::clicked;long		lcnt
string	smchno

if dw_insert.accepttext() = -1 then return

smchno = trim(dw_insert.getitemstring(1,'mchno'))
//
select count(*) into :lcnt from mesmst
 where sabu = :gs_sabu and mchno = :smchno ;
 
if lcnt = 0 then return

setpointer(hourglass!)
dw_insert.setredraw(false)
if dw_insert.retrieve(gs_sabu,smchno) < 1 then
	dw_insert.insertrow(0)
	dw_insert.object.mchno[1] = smchno
	dw_insert.setitem(1,'lasdat',f_today())
	dw_insert.setredraw(true)
	f_message_chk(50, '[계측기기 마스터]')
	dw_insert.setfocus()
	return
end if

dw_insert.setredraw(true)
wf_load_image()
ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_st22_00020
integer x = 4078
end type

event p_del::clicked;string	smchno
Long ll_cnt1, ll_cnt2, ll_cnt3


if dw_insert.getitemstring(1,'create_flag') = 'Y' then return

if f_msg_delete() = -1 then return

smchno = trim(dw_insert.getitemstring(1,'mchno'))

SELECT COUNT(*) INTO :ll_cnt1 FROM MCHMST_INSP WHERE MCHNO = :smchno;
SELECT COUNT(*) INTO :ll_cnt2 FROM MESKWA WHERE MCHNO = :smchno;
SELECT COUNT(*) INTO :ll_cnt3 FROM lw_mchmes_image Where sabu = :gs_sabu And mchgb = '2' And mchno = :smchno;

IF ll_cnt1 > 0 AND ll_cnt2 > 0 THEN
	MessageBox("알림", "이력데이타가 있습니다. 삭제하시려면 계측기기 점검기준등록, 계측기기 결과등록의 데이타를 먼저 삭제하십시요")
	RETURN
ELSEIF ll_cnt1 > 0 THEN
	MessageBox("알림", "이력데이타가 있습니다. 삭제하시려면 계측기기 점검기준등록의 데이타를 먼저 삭제하십시요")
	RETURN
ELSEIF ll_cnt2 > 0 THEN
	MessageBox("알림", "이력데이타가 있습니다. 삭제하시려면 계측기기 결과등록의 데이타를 먼저 삭제하십시요")
	RETURN
END IF

IF ll_cnt3 > 0 THEN
	smchno = trim(dw_insert.getitemstring(1,'mchno'))
	DELETE From lw_mchmes_image
	Where sabu = :gs_sabu And mchgb = '2' And mchno = :smchno;
END IF

dw_insert.setredraw(false)
dw_insert.deleterow(0)
	

if dw_insert.update() <> 1 then
	rollback ;
	messagebox("삭제실패", "계측기기 마스타 삭제 실패!!!")
	return	
end if

//Delete From lw_mchmes_image
// Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;

commit ;

ib_any_typing = false

wf_initial()

dw_insert.setredraw(true)


end event

type p_mod from w_inherite`p_mod within w_st22_00020
integer x = 3904
end type

event p_mod::clicked;long		icnt
string	smchno

if dw_insert.accepttext() = -1 then return
if wf_required_chk() = -1 then return
if f_msg_update() = -1 then return

setpointer(hourglass!)
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("저장실패", "계측기기 마스타 저장 실패!!!")
	return
end if

commit ;

wf_save_image()

ib_any_typing = false
p_inq.postevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_st22_00020
end type

type cb_mod from w_inherite`cb_mod within w_st22_00020
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_st22_00020
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_st22_00020
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_st22_00020
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_st22_00020
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_st22_00020
end type

type cb_can from w_inherite`cb_can within w_st22_00020
end type

type cb_search from w_inherite`cb_search within w_st22_00020
end type







type gb_button1 from w_inherite`gb_button1 within w_st22_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_st22_00020
end type

type st_2 from statictext within w_st22_00020
integer x = 3054
integer y = 264
integer width = 311
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 28144969
long backcolor = 32106727
string text = "IMAGE"
boolean focusrectangle = false
end type

type p_2 from picture within w_st22_00020
integer x = 3067
integer y = 576
integer width = 1472
integer height = 1128
boolean bringtotop = true
boolean border = true
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_st22_00020
integer x = 2405
integer y = 1680
integer height = 76
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('opdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'opdate', gs_code)

end event

type pb_2 from u_pb_cal within w_st22_00020
integer x = 901
integer y = 1580
integer height = 76
integer taborder = 160
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('lasdat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'lasdat', gs_code)

end event

type pb_3 from u_pb_cal within w_st22_00020
integer x = 2405
integer y = 1016
integer height = 76
integer taborder = 170
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('makedate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'makedate', gs_code)

end event

type p_3 from uo_picture within w_st22_00020
integer x = 3557
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

event clicked;call super::clicked;wf_copy()
end event

type p_1 from uo_picture within w_st22_00020
integer x = 4334
integer y = 252
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\그림등록_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\그림등록_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\그림등록_up.gif"
end event

event clicked;call super::clicked;wf_upload()
end event

type pb_4 from u_pb_cal within w_st22_00020
integer x = 2409
integer y = 1352
integer height = 76
integer taborder = 180
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('yudat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'yudat', gs_code)

end event

type pb_5 from u_pb_cal within w_st22_00020
integer x = 901
integer y = 1012
integer height = 76
integer taborder = 160
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('buydate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'buydate', gs_code)

end event

type rr_2 from roundrectangle within w_st22_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33551600
integer x = 23
integer y = 212
integer width = 2994
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_st22_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3026
integer y = 212
integer width = 1568
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_qa02_00017_han_p.srw
$PBExportComments$부적합 현황-한텍
forward
global type w_qa02_00017_han_p from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa02_00017_han_p
end type
type pb_2 from u_pb_cal within w_qa02_00017_han_p
end type
type rr_1 from roundrectangle within w_qa02_00017_han_p
end type
end forward

global type w_qa02_00017_han_p from w_standard_print
integer width = 4667
integer height = 2468
string title = "품질 부적합 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qa02_00017_han_p w_qa02_00017_han_p

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ssdate, sedate, sgubun, sstatus, sdptgu, snull, sgubun2, sprtgbn
String ls_saupj, ls_ittyp, ls_clagbn

If dw_ip.accepttext() = -1 Then Return -1
SetNull(snull)

ls_saupj = dw_ip.getitemstring(1,"saupj")
IF IsNull(ls_saupj) or trim(ls_saupj) = '' THEN
   f_message_chk(33, '[사업장]')
	RETURN -1
END IF

ssdate = trim(dw_ip.getitemstring(1, "sdate"))
sedate = trim(dw_ip.getitemstring(1, "edate"))
sgubun = trim(dw_ip.getitemstring(1, "fagbn"))
sgubun2= trim(dw_ip.getitemstring(1, "status"))
sprtgbn= trim(dw_ip.getitemstring(1, "prtgbn"))
ls_ittyp= trim(dw_ip.getitemstring(1, "ittyp"))
ls_clagbn = Trim(dw_ip.GetItemString(1, 'clagbn'))
If isnull(ls_ittyp) or trim(ls_ittyp) = '' Then	ls_ittyp = '%'

//If sgubun = '1' Then
//	sstatus = 'Y'
//ElseIf sgubun = '2' Then
//	sstatus = 'N'
//ElseIf sgubun = '3' Then
//	sstatus = 'A'
//Else
//	sstatus = '전체'
//End If

If isnull(ssdate) or trim(ssdate) = '' Then
	ssdate = '10000101'
End If

If isnull(sedate) or trim(sedate) = '' Then
	ssdate = '99991231'
End If

dw_list.dataobject = 'd_qa02_00017_han_p_' + sprtgbn
dw_list.settransobject(sqlca)
dw_print.dataobject = 'd_qa02_00017_han_p_' + sprtgbn
dw_print.settransobject(sqlca)


if sgubun = '%' then
	if sprtgbn <> 'a' then
		dw_list.object.silqty.visible = false
		dw_list.object.silqty_t.visible = false
		dw_list.object.ppm.visible = false
		dw_list.object.ppm_t.visible = false
	end if
else
	if sprtgbn <> 'a' then
		dw_list.object.silqty.visible = true
		dw_list.object.silqty_t.visible = true
		dw_list.object.ppm.visible = true
		dw_list.object.ppm_t.visible = true

		if sgubun = '1' then
			dw_list.object.silqty_t.text = '입고수량'
		elseif sgubun = '2' then
			dw_list.object.silqty_t.text = '생산수량'
		elseif sgubun = '3' or sgubun = '4' or sgubun = '5' then
			dw_list.object.silqty_t.text = '판매수량'
		end if
	end if
end if

If Trim(ls_clagbn) = '' OR IsNull(ls_clagbn) Then ls_clagbn = '%'

dw_list.Setredraw(False)

If dw_list.Retrieve(ssdate, sedate, sgubun, sgubun2, ls_saupj, ls_ittyp, ls_clagbn) > 0 Then
//	if sstatus <> '전체' then
//		dw_list.setfilter("status = '"+ sstatus +"'")
//		dw_list.filter()
//		dw_list.SetFilter('')
//	end if
Else
   f_message_chk(50, '[부적합 현황]')
End If

dw_list.Setredraw(True)
dw_list.ShareData(dw_print)
return 1
end function

on w_qa02_00017_han_p.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa02_00017_han_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'saupj',gs_saupj)
dw_ip.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_qa02_00017_han_p
boolean visible = true
integer x = 4247
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_qa02_00017_han_p
integer x = 4727
integer y = 36
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_qa02_00017_han_p
boolean visible = false
integer x = 4960
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_qa02_00017_han_p
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_qa02_00017_han_p
boolean visible = false
integer x = 4805
integer y = 200
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa02_00017_han_p
integer x = 4073
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_qa02_00017_han_p
end type



type dw_print from w_standard_print`dw_print within w_qa02_00017_han_p
integer x = 4027
integer y = 0
string dataobject = "d_qa02_00017_han_p_a"
end type

type dw_ip from w_standard_print`dw_ip within w_qa02_00017_han_p
integer x = 14
integer width = 3808
integer height = 216
string dataobject = "d_qa02_00017_han_p_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string snull, sdata , sname, scode
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'sdate' then
	sdata = this.gettext()
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[시작일자]');
		this.setitem(1, "sdate", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'edate' then
	sdata = this.gettext()	
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[종료일자]');
		this.setitem(1, "edate", snull)
		return 1		
	end if
	if this.getitemstring(1, "sdate") > sdata then
		
		
	end if
	
end if


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',sname)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qa02_00017_han_p
integer y = 256
integer width = 4558
integer height = 1992
string dataobject = "d_qa02_00017_han_p_a"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qa02_00017_han_p
integer x = 1691
integer y = 36
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type pb_2 from u_pb_cal within w_qa02_00017_han_p
integer x = 2135
integer y = 36
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_qa02_00017_han_p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 248
integer width = 4585
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type


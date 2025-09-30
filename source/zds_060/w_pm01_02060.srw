$PBExportHeader$w_pm01_02060.srw
$PBExportComments$계획 ORDER 확정
forward
global type w_pm01_02060 from window
end type
type p_3 from picture within w_pm01_02060
end type
type p_2 from uo_picture within w_pm01_02060
end type
type p_1 from uo_picture within w_pm01_02060
end type
type dw_3 from datawindow within w_pm01_02060
end type
type st_1 from statictext within w_pm01_02060
end type
type dw_2 from datawindow within w_pm01_02060
end type
type dw_1 from datawindow within w_pm01_02060
end type
type gb_2 from groupbox within w_pm01_02060
end type
end forward

global type w_pm01_02060 from window
integer x = 329
integer y = 312
integer width = 1280
integer height = 1288
boolean titlebar = true
string title = "계획오더확정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_3 p_3
p_2 p_2
p_1 p_1
dw_3 dw_3
st_1 st_1
dw_2 dw_2
dw_1 dw_1
gb_2 gb_2
end type
global w_pm01_02060 w_pm01_02060

forward prototypes
public subroutine wf_moveset (integer gubun, long dactno, long daddactno, string smrptxt, string saddmrptxt)
public function integer wf_set (decimal dactno)
end prototypes

public subroutine wf_moveset (integer gubun, long dactno, long daddactno, string smrptxt, string saddmrptxt);dw_3.reset()

If gubun = -1 then
	return
End if

dw_1.accepttext()
dw_3.insertrow(0)

String  sActno, sAddactno

if isnull(dActno) then dactno = 0
if isnull(daddActno) then daddactno = 0

sActno 		= string(dActno)
sAddActno 	= string(dAddActno)

// 실행번호가 없으면 해당 선택내역도 화면에서 삭제
if dactno = 0 then
	dw_3.object.gsabu.visible = '0'
	dw_3.object.naeja.visible = '0'	
	dw_3.object.waija.visible = '0'	
	dw_3.object.mon1.visible  = '0'	
	dw_3.object.mon2.visible  = '0'	
	dw_3.object.mon3.visible  = '0'	
	dw_3.object.mon4.visible  = '0'	
	dw_3.object.mon5.visible  = '0'	
Else	
	dw_3.object.naeja.visible = '1'	
	dw_3.object.waija.visible = '1'	
	dw_3.object.mon1.visible  = '1'	
	dw_3.object.mon2.visible  = '1'	
	dw_3.object.mon3.visible  = '1'	
	dw_3.object.mon4.visible  = '1'	
	dw_3.object.mon5.visible  = '1'		
	
	// Factor적용인 경우 총소요량 계산 Column을 해제
	if sMrptxt = 'FACTOR적용안함'then
		dw_3.object.gsabu.visible = '1'
		dw_3.setitem(1, "gsabu", 'Y')
		dw_3.setitem(1, "naeja", 'N')
		dw_3.setitem(1, "waija", 'Y')
	Else
		dw_3.object.gsabu.visible = '0'		
		dw_3.setitem(1, "gsabu", 'N')
		dw_3.setitem(1, "naeja", 'Y')
		dw_3.setitem(1, "waija", 'N')
	End if	
	
End if
if dAddactno = 0 then
	dw_3.object.gsabu1.visible = '0'
	dw_3.object.naeja1.visible = '0'	
	dw_3.object.waija1.visible = '0'	
	dw_3.object.mon11.visible  = '0'	
	dw_3.object.mon21.visible  = '0'	
	dw_3.object.mon31.visible  = '0'	
	dw_3.object.mon41.visible  = '0'	
	dw_3.object.mon51.visible  = '0'	
Else	
	dw_3.object.naeja1.visible = '1'	
	dw_3.object.waija1.visible = '1'	
	dw_3.object.mon11.visible  = '1'	
	dw_3.object.mon21.visible  = '1'	
	dw_3.object.mon31.visible  = '1'	
	dw_3.object.mon41.visible  = '1'	
	dw_3.object.mon51.visible  = '1'		
	// Factor적용인 경우 총소요량 계산 Column을 해제
	if saddMrptxt = 'FACTOR적용안함'then
		dw_3.object.gsabu1.visible = '1'
		dw_3.setitem(1, "gsabu1", 'Y')
		dw_3.setitem(1, "naeja1", 'N')
		dw_3.setitem(1, "waija1", 'Y')		
	Else
		dw_3.object.gsabu1.visible = '0'
		dw_3.setitem(1, "gsabu1", 'N')
		dw_3.setitem(1, "naeja1", 'Y')
		dw_3.setitem(1, "waija1", 'N')
	End if		
End if

// 전송내역 기본 Setting
dw_3.object.text1.text = '구매계획전송 [실행번호('+String(sActno)		+') 계산기준('+sMrptxt+') ] '
dw_3.object.text2.text = '구매계획전송 [실행번호('+String(sAddActno)	+') 계산기준('+sAddMrptxt+') ] '
end subroutine

public function integer wf_set (decimal dactno);String syymm, sgijun, stxt, srun, ssidat, seddat, spdtsnd, smatsnd, scalgu, sdelete, snull, &
		 saddmrptxt
dec	 dseq, daddno 


dw_2.retrieve(gs_sabu, dactno)	
	
select mrpgiyymm, mrpseq, mrpdata, mrptxt, mrprun, mrpsidat, mrpeddat,
		 mrppdtsnd, mrpmatsnd, mrpcalgu, mrpdelete, mrpaddno
  into :syymm, :dseq, :sgijun, :stxt, :srun, :ssidat, :seddat,
		 :spdtsnd, :smatsnd, :scalgu, :sdelete, :daddno 
  from mrpsys
 where sabu = :gs_sabu and actno = :dActno;

If IsNull(spdtsnd) Or spdtsnd <> 'Y' Then spdtsnd = 'N'

If spdtsnd = 'Y' Then
	p_3.PictureName = 'C:\erpman\image\확정취소_up.gif'
	p_1.PictureName = 'C:\erpman\image\확정_d.gif'
	p_3.Enabled = True
	p_1.Enabled = False
Else
	p_3.PictureName = 'C:\erpman\image\확정취소_d.gif'
	p_1.PictureName = 'C:\erpman\image\확정_up.gif'
	p_3.Enabled = False
	p_1.Enabled = True
End If

if sqlca.sqlcode = 0 then
	dw_1.setitem(1, "yymm", syymm)
	dw_1.setitem(1, "seq",  dseq)
	dw_1.setitem(1, "gijun", sgijun)
	dw_1.setitem(1, "mrptxt", stxt)
	dw_1.setitem(1, "mrprun", srun)
	dw_1.setitem(1, "sidat", ssidat)
	dw_1.setitem(1, "eddat", seddat)
	dw_1.setitem(1, "pdtsndgu", spdtsnd)
	dw_1.setitem(1, "matsndgu", smatsnd)
	dw_1.setitem(1, "pdtsnd", 'N')	
	dw_1.setitem(1, "matsndgu", smatsnd)
	dw_1.setitem(1, "matsnd", 'N')
	dw_1.setitem(1, "calgu", scalgu)
	dw_1.setitem(1, "delgu", sdelete)
	dw_1.setitem(1, "addactno", daddno)
	
	select mrptxt
	  into :saddmrptxt
	  from mrpsys
	 where sabu = :gs_sabu and actno = :daddno;	
	dw_1.setitem(1, "addmrptxt", saddmrptxt) 
	
	wf_moveset(1, dActno, dAddno, stxt, saddmrptxt)
	
	return 1	
else
	setnull(sNull)	
	dw_1.setitem(1, "actno", 0)	
	dw_1.setitem(1, "yymm", snull)
	dw_1.setitem(1, "seq",   snull)
	dw_1.setitem(1, "gijun",  snull)
	dw_1.setitem(1, "mrptxt",  snull)
	dw_1.setitem(1, "mrprun", snull)
	dw_1.setitem(1, "sidat", snull)
	dw_1.setitem(1, "eddat", snull)
	dw_1.setitem(1, "pdtsndgu", snull)
	dw_1.setitem(1, "matsndgu", snull)
	dw_1.setitem(1, "pdtsnd", snull)
	dw_1.setitem(1, "matsndgu", snull)
	dw_1.setitem(1, "matsnd", snull)
	dw_1.setitem(1, "calgu", snull)
	dw_1.setitem(1, "delgu", snull)
	dw_1.setitem(1, "addactno", snull)
	dw_1.setitem(1, "addmrptxt", snull) 	

	wf_moveset(-1, 0, 0, '', '')
	
	return -1
end if


end function

on w_pm01_02060.create
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.dw_3=create dw_3
this.st_1=create st_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_2=create gb_2
this.Control[]={this.p_3,&
this.p_2,&
this.p_1,&
this.dw_3,&
this.st_1,&
this.dw_2,&
this.dw_1,&
this.gb_2}
end on

on w_pm01_02060.destroy
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_3)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_2)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_1.insertrow(0)
dw_3.insertrow(0)
dec	  dactno

Select Max(Actno) into :dactno from mrpsys;
wf_set(dactno)

dw_1.setitem(1, "actno", dactno)
dw_1.setfocus()


end event

type p_3 from picture within w_pm01_02060
integer x = 695
integer y = 24
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "C:\erpman\image\확정취소_up.gif"
boolean focusrectangle = false
end type

event clicked;//// 월 생산계획
//if sgijun = '2' then
//	Sqlca.erp000000050_7_leewon(gs_sabu, dactno, syymm, dseq, sgijun, spdupt, smaupt, serror)
//Else
//	Sqlca.erp000000050_7_leewon(gs_sabu, dactno, ssidat, dseq, sgijun, spdupt, smaupt, serror)
//End If
//
//Commit;
//
//IF serror <> 'N' THEN
//	messagebox("확 인", "계획ORDER 확정이 실패하였습니다.!!")
//else
//	messagebox("확 인", "계획ORDER 확정이 되었읍니다.!!")
//	
//	// 생산계획 전송인 경우 참조코드(04-2)에 실행순번을 저장
//	if spdupt = 'Y' then
//		Update reffpf
//			Set rfna2 = to_char(:dactno)
//		 Where sabu = '1' and rfcod = '1A' and rfgub = '2';
//		if sqlca.sqlcode <> 0 then		 
//			Messagebox("참조코드오류", sqlca.sqlerrtext)
//		end if		 
//	End if
end event

type p_2 from uo_picture within w_pm01_02060
integer x = 1047
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

type p_1 from uo_picture within w_pm01_02060
integer x = 873
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\confirm.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event clicked;call super::clicked;if dw_1.accepttext() = -1 then return
if dw_3.accepttext() = -1 then return

dec dActno, dseq
dec daddActno
String serror, syymm, sgijun, spdupt, smaupt, sCalgu, sDelgu, sPdtsnd, sMatsnd, sPdtgu, sSave, sSave1, ssidat
String sNaeja,  sWaija,  swan
String sNaeja1, sWaija1
Decimal {2} dMon1, dMon2, dMon3, dMon4, dMon5
Decimal {2} dMon11, dMon21, dMon31, dMon41, dMon51

/* 완제품 품목에 대한 FACTOR적용 기준 */
SELECT DATANAME
  INTO :swan
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = 26 and LINENO = '2';

if sqlca.sqlcode <> 0 or isnull( swan ) then
	sWan = '2'
end if

dactno 	= dw_1.getitemdecimal(1, "actno")
dseq		= dw_1.getitemdecimal(1, "seq")
sgijun	= dw_1.getitemstring(1, "gijun")
spdupt	= dw_1.getitemstring(1, "pdtsnd")
smaupt	= dw_1.getitemstring(1, "matsnd")
scalgu	= dw_1.getitemstring(1, "calgu")
sdelgu	= dw_1.getitemstring(1, "delgu")

sNaeJa   = dw_3.getitemstring(1, "naeja")
sWaiJa   = dw_3.getitemstring(1, "waija")
dMon1		= dw_3.getitemDecimal(1, "mon1")
dMon2		= dw_3.getitemDecimal(1, "mon2")
dMon3		= dw_3.getitemDecimal(1, "mon3")
dMon4		= dw_3.getitemDecimal(1, "mon4")
dMon5		= dw_3.getitemDecimal(1, "mon5")
ssave		= dw_3.getitemString(1, "gsabu")

dAddactno = dw_1.getitemdecimal(1, "addactno")
sNaeJa1   = dw_3.getitemstring(1, "naeja1")
sWaiJa1   = dw_3.getitemstring(1, "waija1")
dMon11	 = dw_3.getitemDecimal(1, "mon11")
dMon21	 = dw_3.getitemDecimal(1, "mon21")
dMon31	 = dw_3.getitemDecimal(1, "mon31")
dMon41	 = dw_3.getitemDecimal(1, "mon41")
dMon51	 = dw_3.getitemDecimal(1, "mon51")
ssave1	 = dw_3.getitemString(1, "gsabu1")

syymm		= dw_1.getitemstring(1, "yymm")
ssidat	= dw_1.getitemstring(1, "sidat")


SetPointer(HourGlass!)

// 첫번째 내역을 전송한다. 

if isnull(dactno) or dactno = 0 then
	Messagebox("실행순번", "실행순번이 부정확합니다", stopsign!)
	return
end if

if isnull(scalgu) or trim(scalgu) = '' or scalgu = 'N' then
	Messagebox("계산구분", "정상적으로 계산되지 않은 소요량 입니다.", stopsign!)
	return
end if

if isnull(sdelgu) or trim(sdelgu) = '' or sdelgu = 'Y' then
	Messagebox("자료구분", "소요량 자료가 없읍니다.", stopsign!)
	return
end if

// 실행순번의 전송구분을 검색하여 기 전송된 내역이면 전송 취소
Select mrppdtsnd, mrpmatsnd into :spdtsnd, :smatsnd
  from mrpsys
 where sabu = :gs_sabu and actno = :dactno;
 
if sqlca.sqlcode <> 0 THEN
	Messagebox("MRP실행 이력", "MRP실행이력을 조회할 수 없읍니다.", stopsign!)
	return	
END IF

// 생산계획이 이미 전송된 경우 전송취소로 setting
if spdtsnd = 'Y' then
	spdupt = 'N'
end if

// 자재계획이 이미 전송된 경우 전송취소로 setting
if smatsnd = 'Y' then
	smaupt = 'N'
end if

Long Lrow,  Lchk

Lrow = 0

// 기존 구매계획을 check하여 삭제후 전송 할 것인 지 check
if sMaupt = 'Y' then
		// 월 생산계획	=> 월구매계획
		if sgijun = '2' then
			Select count(*) into :Lrow
			  from PU02_MONPLAN_SUM
			 where sabu   = :gs_sabu and YYMM = :syymm 
				and WAIGB  = '1';
		// 주간 생산계획	=> 주간구매계획
		Else

		end if

		if Lrow > 0 then 
			Lchk =  Messagebox("구매계획", "구매계획이 이미 있읍니다" + '~n' + &
													 "삭제하시겠읍니까?", question!, yesnocancel!) 
			if Lchk = 3 Then 
				st_1.text = ''
				return
			end if		
		end if
end if

// 기존 생산계획을 check하여 삭제후 전송 할 것인 지 check
if sPdupt = 'Y' then
	Lrow = 0
	
	// 월 생산계획
	if sgijun = '2' then
		if swan = '1' then
			Select count(*) into :Lrow
			  from monpln_dtl
			 Where sabu 	= :gs_sabu
				and monyymm = :syymm
				and moseq 	= :dSeq ;
		else
			Select count(*) into :Lrow
			  from monpln_dtl
			 Where sabu 	= :gs_sabu
				and monyymm = :syymm
				and moseq 	= :dSeq 
				and mogub	> '1';				
		end if
	Else

	end if

	if Lrow > 0 then 
		Lchk =  Messagebox("생산계획", "생산계획이 이미 있읍니다" + '~n' + &
												 "삭제하시겠읍니까?", question!, yesnocancel!) 
		if Lchk = 3 Then 
			st_1.text = ''
			return
		end if
	end if
end if

Commit;
		

st_1.text = '자료를 확정중입니다'
serror = 'X'

// 월 생산계획
if sgijun = '2' then
	Sqlca.erp000000050_7_leewon(gs_sabu, dactno, syymm, dseq, sgijun, spdupt, smaupt, serror)
Else
	Sqlca.erp000000050_7_leewon(gs_sabu, dactno, ssidat, dseq, sgijun, spdupt, smaupt, serror)
End If

Commit;

IF serror <> 'N' THEN
	messagebox("확 인", "계획ORDER 확정이 실패하였습니다.!!")
else
	messagebox("확 인", "계획ORDER 확정이 되었읍니다.!!")
	
	// 생산계획 전송인 경우 참조코드(04-2)에 실행순번을 저장
	if spdupt = 'Y' then
		Update reffpf
			Set rfna2 = to_char(:dactno)
		 Where sabu = '1' and rfcod = '1A' and rfgub = '2';
		if sqlca.sqlcode <> 0 then		 
			Messagebox("참조코드오류", sqlca.sqlerrtext)
		end if		 
	End if
	
	// 구매계획 전송(총소요량 전송)인 경우 참조코드(99-3)에 실행순번을 저장
	if ssave = 'Y' then
		Update reffpf
			Set rfna2 = to_char(:dactno)
		 Where sabu = '1' and rfcod = '1A' and rfgub = '3';
		if sqlca.sqlcode <> 0 then		 
			Messagebox("참조코드오류", sqlca.sqlerrtext)
		end if		 
	End if	
	
	Commit;
	
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

type dw_3 from datawindow within w_pm01_02060
integer x = 1317
integer y = 704
integer width = 1664
integer height = 688
integer taborder = 20
string dataobject = "d_pdt_01050_2"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_pm01_02060
integer x = 46
integer y = 1080
integer width = 1202
integer height = 92
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_pm01_02060
integer x = 1294
integer y = 188
integer width = 1746
integer height = 484
string dataobject = "d_pdt_01050_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_pm01_02060
integer x = 18
integer y = 164
integer width = 1253
integer height = 896
integer taborder = 10
string dataobject = "d_pm01_02060_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if this.accepttext() = -1 then return 1

decimal dactno

if this.getcolumnname() = 'actno' then
	dactno = dec(this.gettext())
		 
	if wf_set(dactno) = -1 then
		f_message_chk(33, '[MRP실행순번]')
		return 1
	end if;
	
end if
end event

event itemerror;return 1
end event

event rbuttondown;

open(w_mrpsys_popup_lw)

this.setitem(1, "actno", double(gs_code))
this.triggerevent(itemchanged!)
end event

type gb_2 from groupbox within w_pm01_02060
integer x = 27
integer y = 1036
integer width = 1234
integer height = 152
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type


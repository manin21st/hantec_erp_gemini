$PBExportHeader$w_pdt_01050.srw
$PBExportComments$계획오더확정 선택
forward
global type w_pdt_01050 from window
end type
type p_2 from uo_picture within w_pdt_01050
end type
type p_1 from uo_picture within w_pdt_01050
end type
type dw_3 from datawindow within w_pdt_01050
end type
type st_1 from statictext within w_pdt_01050
end type
type dw_2 from datawindow within w_pdt_01050
end type
type dw_1 from datawindow within w_pdt_01050
end type
type gb_2 from groupbox within w_pdt_01050
end type
type rr_1 from roundrectangle within w_pdt_01050
end type
type rr_2 from roundrectangle within w_pdt_01050
end type
end forward

global type w_pdt_01050 from window
integer x = 329
integer y = 312
integer width = 3099
integer height = 1676
boolean titlebar = true
string title = "계획오더확정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_2 p_2
p_1 p_1
dw_3 dw_3
st_1 st_1
dw_2 dw_2
dw_1 dw_1
gb_2 gb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_01050 w_pdt_01050

forward prototypes
public function integer wf_set (decimal dactno)
public subroutine wf_moveset (integer gubun, long dactno, long daddactno, string smrptxt, string saddmrptxt)
end prototypes

public function integer wf_set (decimal dactno);String syymm, sgijun, stxt, srun, ssidat, seddat, spdtsnd, smatsnd, scalgu, sdelete, snull, &
		 saddmrptxt, ssaupj
dec	 dseq, daddno 


dw_2.retrieve(gs_sabu, dactno)	
dw_3.retrieve(gs_sabu, dactno)
	
select mrpgiyymm, mrpseq, mrpdata, mrptxt, mrprun, mrpsidat, mrpeddat,
		 mrppdtsnd, mrpmatsnd, mrpcalgu, mrpdelete, mrpaddno, saupj
  into :syymm, :dseq, :sgijun, :stxt, :srun, :ssidat, :seddat,
		 :spdtsnd, :smatsnd, :scalgu, :sdelete, :daddno, :ssaupj 
  from mrpsys
 where sabu = :gs_sabu and actno = :dActno;

if sqlca.sqlcode = 0 And sgijun < '3' then

	dw_1.setitem(1, "yymm", syymm)
	dw_1.setitem(1, "seq",  dseq)
	dw_1.setitem(1, "saupj",  ssaupj)	
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
	
	if sqlca.sqlcode = 0 And sgijun > '2' then
		MessageBox("확정", "주간 소요량 확정은 주간영업계획 또는 주간생산계획에서만" + '~n' + &
							    "가능합니다", information!)
	end if
		
	
	setnull(sNull)	
	dw_1.setitem(1, "actno", 0)	
	dw_1.setitem(1, "yymm", snull)
	dw_1.setitem(1, "seq",   snull)
	dw_1.setitem(1, "saupj",  sNull)	
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

public subroutine wf_moveset (integer gubun, long dactno, long daddactno, string smrptxt, string saddmrptxt);If gubun = -1 then
	return
End if

dw_1.accepttext()

String  sActno, sAddactno

if isnull(dActno) then dactno = 0
if isnull(daddActno) then daddactno = 0

sActno 		= string(dActno)
sAddActno 	= string(dAddActno)


end subroutine

on w_pdt_01050.create
this.p_2=create p_2
this.p_1=create p_1
this.dw_3=create dw_3
this.st_1=create st_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_2,&
this.p_1,&
this.dw_3,&
this.st_1,&
this.dw_2,&
this.dw_1,&
this.gb_2,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_01050.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_3)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;f_window_center(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

dw_1.insertrow(0)
dec	  dactno

Select Max(Actno) into :dactno from mrpsys where sabu = :gs_sabu and saupj = :gs_saupj;
wf_set(dactno)

dw_1.setitem(1, "actno", dactno)
dw_1.setfocus()


end event

type p_2 from uo_picture within w_pdt_01050
integer x = 2871
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

type p_1 from uo_picture within w_pdt_01050
integer x = 2697
integer y = 16
integer width = 178
string pointer = "C:\erpman\cur\confirm.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;if dw_1.accepttext() = -1 then return

dec dActno, dseq
dec daddActno
String serror, syymm, sgijun, spdupt, smaupt, sCalgu, sDelgu, sPdtsnd, sMatsnd, sPdtgu, swan

/* 완제품 품목에 대한 FACTOR적용 기준 */
SELECT DATANAME
  INTO :swan
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = 26 and LINENO = '2';

if sqlca.sqlcode <> 0 or isnull( swan ) then
	sWan = '2'
end if

dactno 	= dw_1.getitemdecimal(1, "actno")
syymm		= dw_1.getitemstring(1, "yymm")
dseq		= dw_1.getitemdecimal(1, "seq")
sgijun	= dw_1.getitemstring(1, "gijun")
spdupt	= dw_1.getitemstring(1, "pdtsnd")
smaupt	= dw_1.getitemstring(1, "matsnd")
scalgu	= dw_1.getitemstring(1, "calgu")
sdelgu	= dw_1.getitemstring(1, "delgu")
dAddactno = dw_1.getitemdecimal(1, "addactno")
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
		if sgijun = '1' then
			Select count(*) into :Lrow
			  from yeapln_meip
			 where sabu   = :gs_sabu and yeayymm like :sYymm||'%'
				and yeacha = :dseq;			
		Else
			Select count(*) into :Lrow
			  from mtrpln_sum
			 where sabu   = :gs_sabu and mtryymm = :syymm 
				and mrseq  = :dSeq;
		end if

		if Lrow > 0 then 
			Lchk =  Messagebox("구매계획", "구매계획이 이미 있읍니다" + '~n' + &
													 "삭제하시겠읍니까?", question!, yesnocancel!) 
			if Lchk = 3 Then 
				st_1.text = ''
				return
			end if
			
			if Lchk = 1 then
				if sgijun = '1' then
					Delete from yeapln_meip
					 where sabu   = :gs_sabu and yeayymm like :sYymm||'%'
						and yeacha = :dseq;
						
               IF SQLCA.SQLNROWS <= 0	THEN	
						MESSAGEBOX("확 인", "삭제 실패")
						RETURN 
					END IF						
						
				Else
					Delete from mtrpln_sum
					 where sabu   = :gs_sabu and mtryymm = :syymm
						and mrseq  = :dSeq;

               IF SQLCA.SQLNROWS <= 0	THEN	
						MESSAGEBOX("확 인", "삭제 실패")
						RETURN 
					END IF
	
				   DELETE FROM MTRPLN_INT  
					 WHERE SABU = :gs_sabu  AND  
							 YYMM = :syymm;

				end if
			end if
		
		end if
end if

// 기존 생산계획을 check하여 삭제후 전송 할 것인 지 check
if sPdupt = 'Y' then
	Lrow = 0
		if sgijun = '1' then
			if swan = '1' then
				Select count(*) into :Lrow
				  from yeapln
				 Where sabu 	= :gs_sabu
					and yeayymm like :syymm||'%'
					and yeacha 	= :dSeq 
					and yeagu	= 'A' ;
			else
				Select count(*) into :Lrow
				  from yeapln
				 Where sabu 	= :gs_sabu
					and yeayymm like :syymm||'%'
					and yeacha 	= :dSeq 
					and yeagu	= 'A' 
					and ypgub	> '1';
			end if
		Else
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
		end if
		
		
		if Lrow > 0 then 
			Lchk =  Messagebox("생산계획", "생산계획이 이미 있읍니다" + '~n' + &
													 "삭제하시겠읍니까?", question!, yesnocancel!) 
			if Lchk = 3 Then 
				st_1.text = ''
				return
			end if
			
			if Lchk = 1 then
				if sgijun = '1' then
					if swan = '1' then
						Delete
						  from yeapln
						 Where sabu 	= :gs_sabu
							and yeayymm like :syymm||'%'
							and yeacha 	= :dSeq
							and yeagu	= 'A' ;
					else
						Delete
						  from yeapln
						 Where sabu 	= :gs_sabu
							and yeayymm like :syymm||'%'
							and yeacha 	= :dSeq
							and yeagu	= 'A' 
							and ypgub	> '1';
					end if
				Else
					if swan = '1' then
						Delete
						  from monpln_dtl
						 Where sabu 	= :gs_sabu
							and monyymm = :syymm
							and moseq 	= :dSeq ;
					else
						Delete
						  from monpln_dtl
						 Where sabu 	= :gs_sabu
							and monyymm = :syymm
							and moseq 	= :dSeq 
							and mogub	> '1';
					end if
				end if
			end if
		
		end if
end if

Commit;
		

st_1.text = '자료를 확정중입니다'
serror = 'X'
Sqlca.erp000000050_7(gs_sabu, dactno, syymm, dseq, sgijun, spdupt, smaupt, 'Y', serror)
							
Commit;							

IF serror <> 'N' THEN
	messagebox("확 인", "계획ORDER1 확정이 실패하였습니다.!!")
else
	messagebox("확 인", "계획ORDER1 확정이 되었읍니다.!!")
	
	// 생산계획 전송인 경우 참조코드(04-2)에 실행순번을 저장
	if spdupt = 'Y' then
		Update reffpf
			Set rfna2 = to_char(:dactno)
		 Where sabu = '1' and rfcod = '1A' and rfgub = '2';
		if sqlca.sqlcode <> 0 then		 
			Messagebox("참조코드오류", sqlca.sqlerrtext)
		end if		 
	End if
	
	Commit;
	
END IF

// 두번째 내역을 전송한다(Factor적용 안한 것은 생산으로 적용을 안한다). 
//spdupt = 'N'
//smaupt = 'N'
//if isnull(daddactno) or daddactno = 0 then
//	return
//end if
//
//SetNull(sCalgu)
//SetNull(sDelgu)
//Select Mrpcalgu, Mrpdelete
//  Into :sCalgu, :sDelgu
//  From Mrpsys
// Where sabu = :gs_sabu and actno = :dAddActno;
//
//if isnull(scalgu) or trim(scalgu) = '' or scalgu = 'N' then
//	Messagebox("계산구분", "정상적으로 계산되지 않은 소요량 입니다.", stopsign!)
//	return
//end if
//
//if isnull(sdelgu) or trim(sdelgu) = '' or sdelgu = 'Y' then
//	Messagebox("자료구분", "소요량 자료가 없읍니다.", stopsign!)
//	return
//end if
//
//// 실행순번의 전송구분을 검색하여 기 전송된 내역이면 전송 취소
//Select mrppdtsnd, mrpmatsnd into :spdtsnd, :smatsnd
//  from mrpsys
// where sabu = :gs_sabu and actno = :dAddactno;
// 
//if sqlca.sqlcode <> 0 THEN
//	Messagebox("MRP실행 이력", "MRP실행이력을 조회할 수 없읍니다.", stopsign!)
//	return	
//END IF
//
//// 생산계획이 이미 전송된 경우 전송취소로 setting
//if spdtsnd = 'Y' then
//	spdupt = 'N'
//end if
//
//// 자재계획이 이미 전송된 경우 전송취소로 setting
//if smatsnd = 'Y' then
//	smaupt = 'N'
//end if
//
//st_1.text = '자료를 확정중입니다'
//serror = 'X'
//Sqlca.erp000000050_7(gs_sabu, dAddactno, syymm, dseq, sgijun, spdupt, smaupt, 'Y', serror)
//							
//commit; 
//
//IF serror <> 'N' THEN
//	messagebox("확 인", "계획ORDER 확정이 실패하였습니다.!!")
//else
//	messagebox("확 인", "계획ORDER 확정이 되었읍니다.!!")
//	
//	// 구매계획 전송(총소요량 전송)인 경우 참조코드(04-3)에 실행순번을 저장
//	Update reffpf
//		Set rfna2 = to_char(:daddactno)
//	 Where sabu = '1' and rfcod = '1A' and rfgub = '3';
//	if sqlca.sqlcode <> 0 then		 
//		Messagebox("참조코드오류", sqlca.sqlerrtext)
//	end if		 
//	Commit;	
//	
//END IF
//
//st_1.text = ''
//
//
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

type dw_3 from datawindow within w_pdt_01050
integer x = 1317
integer y = 704
integer width = 1664
integer height = 688
integer taborder = 20
string dataobject = "d_pdt_01050_2"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_pdt_01050
integer x = 46
integer y = 1460
integer width = 3003
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

type dw_2 from datawindow within w_pdt_01050
integer x = 1294
integer y = 188
integer width = 1746
integer height = 484
string dataobject = "d_pdt_01050_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_pdt_01050
integer x = 18
integer y = 164
integer width = 1253
integer height = 1252
integer taborder = 10
string dataobject = "d_pdt_01050"
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

open(w_mrpsys_popup)

this.setitem(1, "actno", double(gs_code))
this.triggerevent(itemchanged!)
end event

type gb_2 from groupbox within w_pdt_01050
integer x = 27
integer y = 1416
integer width = 3035
integer height = 152
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_pdt_01050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1280
integer y = 180
integer width = 1774
integer height = 500
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_01050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1280
integer y = 696
integer width = 1774
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type


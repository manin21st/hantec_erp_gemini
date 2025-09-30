$PBExportHeader$w_kfic18.srw
$PBExportComments$설비별 월할리스료 현황
forward
global type w_kfic18 from w_standard_print
end type
type cb_1 from commandbutton within w_kfic18
end type
type gb_4 from groupbox within w_kfic18
end type
type dw_1 from datawindow within w_kfic18
end type
type dw_2 from datawindow within w_kfic18
end type
type rr_1 from roundrectangle within w_kfic18
end type
end forward

global type w_kfic18 from w_standard_print
integer x = 0
integer y = 0
string title = "설비별 월할리스료 현황"
cb_1 cb_1
gb_4 gb_4
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
end type
global w_kfic18 w_kfic18

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_yymm, s_lscono, s_lsno

if dw_ip.accepttext() = -1 then return -1

s_yymm = dw_ip.getitemstring(dw_ip.getrow(), "yymm")
s_lscono = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
s_lsno = dw_ip.getitemstring(dw_ip.getrow(), "lsno")

if s_yymm = "" or isnull(s_yymm) then 
	f_messagechk(1, "[기준년월]")
	dw_ip.setcolumn("yymm")
	dw_ip.setfocus()
	return -1
else  
	if f_datechk(s_yymm +'01') = -1 then 
	   messagebox("확인", "유효한 일자가 아닙니다.!!")
	   dw_ip.setcolumn("yymm")
      dw_ip.setfocus()
      return -1 
	end if
end if

if s_lscono = "" or isnull(s_lscono) then
	s_lscono = '%' 
end if

if s_lsno = "" or isnull(s_lsno) then
	s_lsno = '%'
end if

dw_print.object.yymm.text = string(s_yymm, "@@@@.@@")

//if dw_list.retrieve(s_yymm, s_lscono, s_lsno) <= 0 then
//	messagebox("확인", "조회하신 자료가 없습니다. ~n~r" &
// 	           + "월할자료생성 버튼을 누르시면 자료가 생성됩니다.!!")
//	dw_ip.setcolumn("yymm")
//	dw_ip.setfocus()
//	return -1 
//end if

IF dw_print.retrieve(s_yymm, s_lscono, s_lsno) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_kfic18.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.gb_4=create gb_4
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_kfic18.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;string s_yymm
decimal d_crate

dw_1.Settransobject(sqlca)
dw_2.Settransobject(sqlca)

s_yymm = left(f_today(), 6)

dw_ip.setitem(1, "yymm", s_yymm)

//  SELECT "KFZ34OT1"."Y_RATE"  
//    INTO :d_crate  
//    FROM "KFZ34OT1"  
//   WHERE SUBSTR("KFZ34OT1"."CLOSING_DATE", 1, 6) = :s_yymm ;  
//
//
//SELECT MAX("KFZ34OT1"."CLOSING_DATE")
//  FROM "KFZ34OT1"              
// WHERE SUBSTR("KFZ34OT1"."CLOSING_DATE", 1, 6) = :s_yymm ;  
//        
//             
//
//
end event

type p_preview from w_standard_print`p_preview within w_kfic18
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_kfic18
end type

type p_print from w_standard_print`p_print within w_kfic18
integer taborder = 30
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic18
end type

type st_window from w_standard_print`st_window within w_kfic18
integer x = 2373
end type



type dw_datetime from w_standard_print`dw_datetime within w_kfic18
integer x = 2834
end type

type st_10 from w_standard_print`st_10 within w_kfic18
end type



type dw_print from w_standard_print`dw_print within w_kfic18
string dataobject = "d_kfic18_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic18
integer x = 0
integer y = 12
integer width = 2322
integer height = 256
string dataobject = "d_kfic18"
end type

event dw_ip::itemchanged;call super::itemchanged;string s_lscono, s_lsco, s_lsno, s_yymm, snull
decimal d_crate
setnull(snull)

if this.getcolumnname() = "lscono" then
   s_lscono = this.gettext()
	
	if s_lscono = "" or isnull(s_lscono) then 
		this.setitem(dw_ip.getrow(), "lscono", snull)
		this.setitem(dw_ip.getrow(), "lsco", snull)
	end if
		
	SELECT "LSCO"
	  INTO :s_lsco
	  FROM "KFM20M"
	 WHERE "LSCONO" = :s_lscono ;
	 
	 if sqlca.sqlcode = 0 then 
		 this.setitem(this.getrow(), "lsco", s_lsco)
	else 
//		 this.setitem(this.getrow(), "lscono", snull)
//		 this.setitem(this.getrow(), "lsco", snull)
//		 this.setcolumn("lscono")
//		 this.setfocus()
	end if 
end if





end event

event dw_ip::rbuttondown;call super::rbuttondown;this.accepttext()

if this.getcolumnname() = "lscono" then
	gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
   gs_codename = dw_ip.getitemstring(dw_ip.getrow(), "lsco")
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup1)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lscono", gs_code)
	dw_ip.setitem(dw_ip.getrow(), "lsco", gs_codename)
elseif this.getcolumnname() = "lsno" then
	gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lsno")
   
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lsno", gs_code)
	
end if		
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfic18
integer width = 4549
string dataobject = "d_kfic18_1"
boolean border = false
end type

type cb_1 from commandbutton within w_kfic18
integer x = 2377
integer y = 84
integer width = 672
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월할자료생성"
end type

event clicked;string s_yymm, s_lsno, s_lscono, ls_lsno, s_sbno, s_ksbnam, s_esbnam, s_kwdept, &
       s_workstation, s_curr,ss_yymm,ss_lsno,ss_sbno,sClosing_date, msbno
double d_lsamt, d_lsamtf, d_whlsamt, d_whlsamtf, d_sblsamt, d_sblsamtf, ld_whlsamtf, &
        d_chlsamt, d_chwhlsamt, d_chsblsamt,ds_amt,ds_amtf,ds_camt, s_sblsamtf, cha
int i, net, iSourCnt, iDestCnt, iCurRow

if dw_ip.accepttext() = -1 then return -1

s_yymm = dw_ip.getitemstring(dw_ip.getrow(), "yymm")
s_lscono = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
s_lsno = dw_ip.getitemstring(dw_ip.getrow(), "lsno")

if s_yymm = "" or isnull(s_yymm) then 
	f_messagechk(1, "[기준년월]")
	dw_ip.setcolumn("yymm")
	dw_ip.setfocus()
	return -1
else  
	if f_datechk(s_yymm +'01') = -1 then 
	   messagebox("확인", "유효한 일자가 아닙니다.!!")
	   dw_ip.setcolumn("yymm")
      dw_ip.setfocus()
      return -1 
	end if
end if

SELECT CLOSING_DATE
  into :sClosing_date
  FROM KFZ34OT1
 WHERE CLOSING_DATE <= :S_YYMM||'31'
   AND ROWNUM = 1;

if sqlca.sqlcode <> 0 then
	messagebox("확인", "적용할 환율이 없습니다. 먼저 환율을 등록하십시오!!")
	dw_ip.setfocus()
	return 
end if 

if s_lscono = "" or isnull(s_lscono) then
	s_lscono = '%' 
end if

if s_lsno = "" or isnull(s_lsno) then
	s_lsno = '%'
end if

dw_list.object.yymm.text = string(s_yymm, "@@@@.@@")

iDestCnt = dw_1.retrieve(s_yymm, s_lscono, s_lsno)

if iDestCnt > 0 then
	Net = MessageBox("확 인","이미 자료가 존재합니다. 다시 생성하시겠습니까?", Question!, OkCancel!, 1)
	if Net = 1 then
		for i = iDestCnt to 1 Step -1
			dw_1.deleterow(0)
      next
   	if dw_1.update() <> 1 then 
			rollback;
			F_MessageChk(12,'[기존자료]')
			return 
		end if
		commit;
	else
		dw_ip.Setcolumn('yymm')
		dw_ip.setfocus()
		return
	end if
end if

if dw_2.retrieve(s_yymm) <= 0 then
	MessageBox("확 인", "월할 리스료 자료가 존재하지 않습니다.")
	dw_ip.SetColumn('yymm')
   dw_ip.SetFocus()			
	return 
else
	iSourCnt = dw_2.RowCount()	
end if
											
for i = 1 to iSourCnt 
	iCurRow = dw_1.insertrow(0)

	dw_1.SetItem(iCurRow, 'io_yymm',    s_yymm )	
	dw_1.SetItem(iCurRow, 'lsno',       dw_2.GetItemString(i, 'lsno')	)
	dw_1.SetItem(iCurRow, 'sbno',       dw_2.GetItemString(i, 'sbno')	)	
	dw_1.SetItem(iCurRow, 'ksbnam',     dw_2.GetItemString(i, 'ksbnam'))	
	dw_1.SetItem(iCurRow, 'esbnam',     dw_2.GetItemString(i, 'esbnam'))	
	dw_1.SetItem(iCurRow, 'kwdept',     dw_2.GetItemString(i, 'kwdept'))		
	dw_1.SetItem(iCurRow, 'workstation', dw_2.GetItemString(i, 'workstation'))			
	dw_1.SetItem(iCurRow, 'lsamt',     dw_2.GetItemDecimal(i, 'wlsamt'))				
	dw_1.SetItem(iCurRow, 'lsamtf',    dw_2.GetItemDecimal(i, 'ulsamt'))
	dw_1.SetItem(iCurRow, 'curr',      dw_2.GetItemString(i, 'curr'))
	dw_1.SetItem(iCurRow, 'whlsamt',   dw_2.GetItemDecimal(i, 'whlsamt'))
	dw_1.SetItem(iCurRow, 'whlsamtf',  dw_2.GetItemDecimal(i, 'whlsamtf'))
	dw_1.SetItem(iCurRow, 'sblsamt',   dw_2.GetItemDecimal(i, 'sblsamt')	)	
	dw_1.SetItem(iCurRow, 'sblsamtf',  dw_2.GetItemDecimal(i, 'sblsamtf'))	
	dw_1.SetItem(iCurRow, 'chlsamt',   dw_2.GetItemDecimal(i, 'chlsamt'))		
	dw_1.SetItem(iCurRow, 'chwhlsamt', dw_2.GetItemDecimal(i, 'chwhlsamt'))			
	dw_1.SetItem(iCurRow, 'chsblsamt', dw_2.GetItemDecimal(i, 'chsblsamt'))				
	
next

if dw_1.update() <> 1 then 
	rollback;
	F_MessageChk(13,'')
	return 
end if
commit ;

//  DECLARE Cur_Plan CURSOR FOR  
//             select a.io_yymm,
//			           a.lsno,
//						  a.whlsamt - b.amt,
//						  a.whlsamtf - b.amtf,
//                    a.chwhlsamt -  b.camt,
//						  b.sbno
//             from kfm20t3 a,
//                  ( select io_yymm,lsno,max(sbno) sbno, sum(sblsamt) amt,sum(sblsamtf) amtf,sum(chsblsamt) camt
//						    from kfm20t3
//							where io_yymm = :s_yymm
//							group by io_yymm,lsno) b
//            where a.io_yymm = b.io_yymm
//              and a.lsno    = b.lsno
//				  and a.sbno    = b.sbno
//				  and (a.whlsamt - b.amt <> 0 or a.sblsamtf - b.amtf <> 0 or a.chwhlsamt -  b.camt <> 0);
//   OPEN Cur_Plan;
//   FETCH Cur_Plan INTO :ss_yymm,:ss_lsno,:ds_amt,:ds_amtf,:ds_camt,:ss_sbno;
//     DO WHILE SQLCA.SQLCODE = 0
//         update kfm20t3 set sblsamt  = nvl(sblsamt,0) + nvl(:ds_amt,0),
//                            sblsamtf = nvl(sblsamtf,0) + nvl(:ds_amtf,0),
//                            chsblsamt = nvl(chsblsamt,0) + nvl(:ds_camt,0)
//		                where io_yymm = :ss_yymm
//                        and lsno    = :ss_lsno
//                        and sbno    = :ss_sbno
//                        and rownum  = 1;
//          IF SQLCA.SQLCODE <> 0 THEN
//	            F_MessageChk(13,'[원단위조정]')
//		         ROLLBACK ;
//		         CLOSE Cur_Plan;
//		         RETURN
//          END IF
//          FETCH Cur_Plan INTO :ss_yymm,:ss_lsno,:ds_amt,:ds_amtf,:ds_camt,:ss_sbno;
//     LOOP 
//   CLOSE Cur_Plan;
//   commit;
	
	DECLARE cur_plan2 CURSOR FOR
	        select distinct lsno, whlsamtf
			    from kfm20t3
				where io_yymm = :s_yymm ;
	OPEN Cur_plan2;
	DO WHILE TRUE
		FETCH Cur_plan2 INTO :ls_lsno, :ld_whlsamtf;
			IF SQLCA.SQLCODE <> 0 THEN EXIT
				select sum(sblsamtf), max(sbno)
				  into :s_sblsamtf, :msbno
				  from kfm20t3
				  where io_yymm = :s_yymm
					 and lsno = :ls_lsno;
					 
				cha = ld_whlsamtf - s_sblsamtf
				
				update kfm20t3 set sblsamtf = sblsamtf + :cha
				 where io_yymm = :s_yymm
					and lsno = :ls_lsno
					and sbno = :msbno ;
				IF SQLCA.SQLCODE <> 0 THEN
					ROLLBACK;
					CLOSE Cur_plan2;
					return
				END IF
	LOOP
	CLOSE Cur_plan2;
	commit;
			       
dw_list.retrieve(s_yymm, s_lscono, s_lsno)
end event

type gb_4 from groupbox within w_kfic18
integer x = 2327
integer width = 773
integer height = 252
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kfic18
boolean visible = false
integer x = 1138
integer y = 2420
integer width = 1015
integer height = 116
boolean bringtotop = true
boolean titlebar = true
string title = "설비별 월할리스료(저장)"
string dataobject = "d_kfic18_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_kfic18
boolean visible = false
integer x = 64
integer y = 2432
integer width = 1015
integer height = 116
boolean bringtotop = true
boolean titlebar = true
string title = "설비별 월할리스료(조회)"
string dataobject = "d_kfic18_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfic18
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 272
integer width = 4603
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type


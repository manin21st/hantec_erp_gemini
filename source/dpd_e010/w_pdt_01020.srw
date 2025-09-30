$PBExportHeader$w_pdt_01020.srw
$PBExportComments$** 월 생산계획
forward
global type w_pdt_01020 from w_inherite
end type
type gb_3 from groupbox within w_pdt_01020
end type
type gb_2 from groupbox within w_pdt_01020
end type
type dw_1 from datawindow within w_pdt_01020
end type
type dw_hidden from datawindow within w_pdt_01020
end type
type dw_hist from u_key_enter within w_pdt_01020
end type
type dw_jego from datawindow within w_pdt_01020
end type
type st_2 from statictext within w_pdt_01020
end type
type dw_jego1 from datawindow within w_pdt_01020
end type
type st_3 from statictext within w_pdt_01020
end type
type rr_4 from roundrectangle within w_pdt_01020
end type
end forward

global type w_pdt_01020 from w_inherite
string title = "월 생산계획 조정"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
dw_hidden dw_hidden
dw_hist dw_hist
dw_jego dw_jego
st_2 st_2
dw_jego1 dw_jego1
st_3 st_3
rr_4 rr_4
end type
global w_pdt_01020 w_pdt_01020

type variables
string ls_text, is_pspec, is_jijil
end variables

forward prototypes
public subroutine wf_modify (string s_gub)
public subroutine wf_reset ()
public subroutine wf_setitem (string arg_itnbr, string arg_yymm, integer arg_seq)
public subroutine wf_setnull ()
public subroutine wf_modify1 (string scode)
public function integer wf_required_chk (integer ix)
end prototypes

public subroutine wf_modify (string s_gub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull, ls_colx, scode

setnull(snull)

scode = dw_1.getitemstring(1, "naewi")

if 	scode = '1' Then
	IF 	s_gub = '0' THEN                                                     // 0 : 품목분류,  1 : 품번
		dw_insert.DataObject ="d_pdt_01020_2" 
	ELSE
		dw_insert.DataObject ="d_pdt_01020_1" 
	END IF
Else
	IF 	s_gub = '0' THEN
		dw_insert.DataObject ="d_pdt_01020_21" 
	ELSE
		dw_insert.DataObject ="d_pdt_01020_11" 
	END IF	
End if

dw_insert.SetTransObject(SQLCA)


end subroutine

public subroutine wf_reset ();string syymm
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_hist.reset()
dw_insert.reset()
dw_jego.reset()
dw_jego1.reset()

dw_1.insertrow(0)

//현재월에 맞는 조정차수를 가져온다. 확정계획이 없으면 조정계획을 가져오지 못하고 
//   											 조정계획이 있으면 확정계획을 가죠오지 못한다.	
syymm = left(is_today,6)

dw_1.setitem(1, 'syymm', syymm )

SELECT MAX("MONPLN_SUM"."MOSEQ")  
  INTO :get_yeacha  
  FROM "MONPLN_SUM"  
 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

// 생산팀
f_child_saupj(dw_1, 'steam', gs_saupj)

dw_1.setitem(1, 'jjcha', get_yeacha )
dw_1.setfocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)


end subroutine

public subroutine wf_setitem (string arg_itnbr, string arg_yymm, integer arg_seq);// 년동 계획수량을 가져온다.
Dec{3} dqty1, dqty2, dqty3, dqty4, dqty5
Long   lrow

//  SELECT MONQTY1, MONQTY2, MONQTY3, MONQTY4, MONQTY5  
//    INTO :dqty1,  :dqty2,  :dqty3,  :dqty4,  :dqty5  
//    FROM MONPLN_SUM  
//   WHERE SABU   = :gs_sabu AND MONYYMM = :arg_yymm AND  
//         ITNBR  = :arg_itnbr AND MOSEQ = :arg_seq  ;
//
//lrow = dw_insert.getrow()
//
//dw_insert.setitem(lrow, "monpln_sum_monqty1", dqty1)
//dw_insert.setitem(lrow, "monpln_sum_monqty2", dqty2)
//dw_insert.setitem(lrow, "monpln_sum_monqty3", dqty3)
//dw_insert.setitem(lrow, "monpln_sum_monqty4", dqty4)
//dw_insert.setitem(lrow, "monpln_sum_monqty5", dqty5)

end subroutine

public subroutine wf_setnull ();string snull , sNaewi
long   lrow

setnull(snull)

snaewi = dw_1.GetItemString(1,'naewi')

lrow   = dw_insert.getrow()

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	
dw_insert.setitem(lrow, "ispec", snull)

dw_insert.setitem(lrow, "monqty01", 0)
dw_insert.setitem(lrow, "monqty02", 0)
dw_insert.setitem(lrow, "monqty03", 0)
dw_insert.setitem(lrow, "monqty04", 0)
dw_insert.setitem(lrow, "monqty05", 0)
dw_insert.setitem(lrow, "monqty06", 0)
dw_insert.setitem(lrow, "monqty07", 0)
dw_insert.setitem(lrow, "monqty08", 0)
dw_insert.setitem(lrow, "monqty09", 0)
dw_insert.setitem(lrow, "monqty10", 0)
dw_insert.setitem(lrow, "monqty11", 0)
dw_insert.setitem(lrow, "monqty12", 0)
dw_insert.setitem(lrow, "monqty13", 0)
dw_insert.setitem(lrow, "monqty14", 0)
dw_insert.setitem(lrow, "monqty15", 0)
dw_insert.setitem(lrow, "monqty16", 0)
dw_insert.setitem(lrow, "monqty17", 0)
dw_insert.setitem(lrow, "monqty18", 0)
dw_insert.setitem(lrow, "monqty19", 0)
dw_insert.setitem(lrow, "monqty20", 0)
dw_insert.setitem(lrow, "monqty21", 0)
dw_insert.setitem(lrow, "monqty22", 0)
dw_insert.setitem(lrow, "monqty23", 0)
dw_insert.setitem(lrow, "monqty24", 0)
dw_insert.setitem(lrow, "monqty25", 0)
dw_insert.setitem(lrow, "monqty26", 0)
dw_insert.setitem(lrow, "monqty27", 0)
dw_insert.setitem(lrow, "monqty28", 0)
dw_insert.setitem(lrow, "monqty29", 0)
dw_insert.setitem(lrow, "monqty30", 0)
dw_insert.setitem(lrow, "monqty31", 0)

dw_insert.setitem(lrow, "monpln_sum_monqty1", 0)
dw_insert.setitem(lrow, "monpln_sum_monqty2", 0)
dw_insert.setitem(lrow, "monpln_sum_monqty3", 0)
dw_insert.setitem(lrow, "monpln_sum_monqty4", 0)
dw_insert.setitem(lrow, "monpln_sum_monqty5", 0)


//if	sNaewi = '1'	then 
	dw_insert.setitem(lrow, "monpln_dtl_monqty201", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty202", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty203", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty204", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty205", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty206", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty207", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty208", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty209", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty210", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty211", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty212", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty213", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty214", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty215", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty216", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty217", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty218", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty219", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty220", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty221", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty222", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty223", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty224", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty225", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty226", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty227", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty228", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty229", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty230", 0)
	dw_insert.setitem(lrow, "monpln_dtl_monqty231", 0)
//Else
	dw_insert.setitem(lrow, "monqty101", 0)
	dw_insert.setitem(lrow, "monqty102", 0)
	dw_insert.setitem(lrow, "monqty103", 0)
	dw_insert.setitem(lrow, "monqty104", 0)
	dw_insert.setitem(lrow, "monqty105", 0)
	dw_insert.setitem(lrow, "monqty106", 0)
	dw_insert.setitem(lrow, "monqty107", 0)
	dw_insert.setitem(lrow, "monqty108", 0)
	dw_insert.setitem(lrow, "monqty109", 0)
	dw_insert.setitem(lrow, "monqty110", 0)
	dw_insert.setitem(lrow, "monqty111", 0)
	dw_insert.setitem(lrow, "monqty112", 0)
	dw_insert.setitem(lrow, "monqty113", 0)
	dw_insert.setitem(lrow, "monqty114", 0)
	dw_insert.setitem(lrow, "monqty115", 0)
	dw_insert.setitem(lrow, "monqty116", 0)
	dw_insert.setitem(lrow, "monqty117", 0)
	dw_insert.setitem(lrow, "monqty118", 0)
	dw_insert.setitem(lrow, "monqty119", 0)
	dw_insert.setitem(lrow, "monqty120", 0)
	dw_insert.setitem(lrow, "monqty121", 0)
	dw_insert.setitem(lrow, "monqty122", 0)
	dw_insert.setitem(lrow, "monqty123", 0)
	dw_insert.setitem(lrow, "monqty124", 0)
	dw_insert.setitem(lrow, "monqty125", 0)
	dw_insert.setitem(lrow, "monqty126", 0)
	dw_insert.setitem(lrow, "monqty127", 0)
	dw_insert.setitem(lrow, "monqty128", 0)
	dw_insert.setitem(lrow, "monqty129", 0)
	dw_insert.setitem(lrow, "monqty130", 0)
	dw_insert.setitem(lrow, "monqty131", 0)
//End If	
end subroutine

public subroutine wf_modify1 (string scode);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull, ls_colx, s_gub

setnull(snull)

s_gub = dw_1.getitemstring(1, "sgub")

if scode = '1' Then
	IF s_gub = '0' THEN
		dw_insert.DataObject ="d_pdt_01020_2" 
		dw_insert.SetTransObject(SQLCA)
	ELSE
		dw_insert.DataObject ="d_pdt_01020_1" 
		dw_insert.SetTransObject(SQLCA)
	END IF
Else
	IF s_gub = '0' THEN
		dw_insert.DataObject ="d_pdt_01020_21" 
		dw_insert.SetTransObject(SQLCA)
	ELSE
		dw_insert.DataObject ="d_pdt_01020_11" 
		dw_insert.SetTransObject(SQLCA)
	END IF	
End if


end subroutine

public function integer wf_required_chk (integer ix);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(ix,'itnbr')) or &
	dw_insert.GetItemString(ix,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(ix)+' 행 품번]')
	dw_insert.ScrollToRow(ix)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

//if isnull(dw_insert.GetItemNumber(i,'monqty1')) or &
//	dw_insert.GetItemNumber(i,'monqty1') < 0 then
//   f_message_chk(1400,'[ '+string(i)+' 행  M 월]')
//	dw_insert.ScrollToix(i)
//	dw_insert.SetColumn('monqty1')
//	dw_insert.SetFocus()
//	return -1		
//end if	


return 1
//=====================================================================================

//String scol_name, sNaewi
//Dec {2} dData, dData2
//
//snaewi = dw_1.GetItemString(1,'naewi')
//
//If	snaewi	= '1'	then
//	dData = dw_insert.getitemdecimal(ix, "monqty101")
//	dw_insert.setitem(ix, "monpln_dtl_monqty01", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty201"))
//	dData = dw_insert.getitemdecimal(ix, "monqty102")
//	dw_insert.setitem(ix, "monpln_dtl_monqty02", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty202"))
//	dData = dw_insert.getitemdecimal(ix, "monqty103")
//	dw_insert.setitem(ix, "monpln_dtl_monqty03", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty203"))
//	dData = dw_insert.getitemdecimal(ix, "monqty104")
//	dw_insert.setitem(ix, "monpln_dtl_monqty04", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty204"))
//	dData = dw_insert.getitemdecimal(ix, "monqty105")
//	dw_insert.setitem(ix, "monpln_dtl_monqty05", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty205"))
////---------------------------------------------------------------------------------------------
//	dData = dw_insert.getitemdecimal(ix, "monqty106")
//	dw_insert.setitem(ix, "monpln_dtl_monqty06", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty206"))
//	dData = dw_insert.getitemdecimal(ix, "monqty107")
//	dw_insert.setitem(ix, "monpln_dtl_monqty07", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty207"))
//	dData = dw_insert.getitemdecimal(ix, "monqty108")
//	dw_insert.setitem(ix, "monpln_dtl_monqty08", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty208"))
//	dData = dw_insert.getitemdecimal(ix, "monqty109")
//	dw_insert.setitem(ix, "monpln_dtl_monqty09", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty209"))
//	dData = dw_insert.getitemdecimal(ix, "monqty110")
//	dw_insert.setitem(ix, "monpln_dtl_monqty10", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty210"))
////-------------------------------
//	dData = dw_insert.getitemdecimal(ix, "monqty111")
//	dw_insert.setitem(ix, "monpln_dtl_monqty11", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty211"))
//	dData = dw_insert.getitemdecimal(ix, "monqty112")
//	dw_insert.setitem(ix, "monpln_dtl_monqty12", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty212"))
//	dData = dw_insert.getitemdecimal(ix, "monqty113")
//	dw_insert.setitem(ix, "monpln_dtl_monqty13", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty213"))
//	dData = dw_insert.getitemdecimal(ix, "monqty114")
//	dw_insert.setitem(ix, "monpln_dtl_monqty14", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty214"))
//	dData = dw_insert.getitemdecimal(ix, "monqty115")
//	dw_insert.setitem(ix, "monpln_dtl_monqty15", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty215"))
//	dData = dw_insert.getitemdecimal(ix, "monqty116")
//	dw_insert.setitem(ix, "monpln_dtl_monqty16", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty216"))
//	dData = dw_insert.getitemdecimal(ix, "monqty117")
//	dw_insert.setitem(ix, "monpln_dtl_monqty17", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty217"))
//	dData = dw_insert.getitemdecimal(ix, "monqty118")
//	dw_insert.setitem(ix, "monpln_dtl_monqty18", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty218"))
//	dData = dw_insert.getitemdecimal(ix, "monqty119")
//	dw_insert.setitem(ix, "monpln_dtl_monqty19", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty219"))
//	dData = dw_insert.getitemdecimal(ix, "monqty120")
//	dw_insert.setitem(ix, "monpln_dtl_monqty20", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty220"))
////-------------------------------
//	dData = dw_insert.getitemdecimal(ix, "monqty121")
//	dw_insert.setitem(ix, "monpln_dtl_monqty21", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty221"))
//	dData = dw_insert.getitemdecimal(ix, "monqty122")
//	dw_insert.setitem(ix, "monpln_dtl_monqty22", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty222"))
//	dData = dw_insert.getitemdecimal(ix, "monqty123")
//	dw_insert.setitem(ix, "monpln_dtl_monqty23", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty223"))
//	dData = dw_insert.getitemdecimal(ix, "monqty124")
//	dw_insert.setitem(ix, "monpln_dtl_monqty24", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty224"))
//	dData = dw_insert.getitemdecimal(ix, "monqty125")
//	dw_insert.setitem(ix, "monpln_dtl_monqty25", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty225"))
//	dData = dw_insert.getitemdecimal(ix, "monqty126")
//	dw_insert.setitem(ix, "monpln_dtl_monqty26", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty226"))
//	dData = dw_insert.getitemdecimal(ix, "monqty127")
//	dw_insert.setitem(ix, "monpln_dtl_monqty27", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty227"))
//	dData = dw_insert.getitemdecimal(ix, "monqty128")
//	dw_insert.setitem(ix, "monpln_dtl_monqty28", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty228"))
//	dData = dw_insert.getitemdecimal(ix, "monqty129")
//	dw_insert.setitem(ix, "monpln_dtl_monqty29", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty229"))
//	dData = dw_insert.getitemdecimal(ix, "monqty130")
//	dw_insert.setitem(ix, "monpln_dtl_monqty30", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty230"))
//	dData = dw_insert.getitemdecimal(ix, "monqty131")
//	dw_insert.setitem(ix, "monpln_dtl_monqty31", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty231"))
//Else
//	dData = dw_insert.getitemdecimal(ix, "monqty201")
//	dw_insert.setitem(ix, "monpln_dtl_monqty01", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty101"))
//	dData = dw_insert.getitemdecimal(ix, "monqty202")
//	dw_insert.setitem(ix, "monpln_dtl_monqty02", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty102"))
//	dData = dw_insert.getitemdecimal(ix, "monqty203")
//	dw_insert.setitem(ix, "monpln_dtl_monqty03", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty103"))
//	dData = dw_insert.getitemdecimal(ix, "monqty204")
//	dw_insert.setitem(ix, "monpln_dtl_monqty04", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty104"))
//	dData = dw_insert.getitemdecimal(ix, "monqty205")
//	dw_insert.setitem(ix, "monpln_dtl_monqty05", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty105"))
////---------------------------------------------------------------------------------------------
//	dData = dw_insert.getitemdecimal(ix, "monqty206")
//	dw_insert.setitem(ix, "monpln_dtl_monqty06", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty106"))
//	dData = dw_insert.getitemdecimal(ix, "monqty207")
//	dw_insert.setitem(ix, "monpln_dtl_monqty07", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty107"))
//	dData = dw_insert.getitemdecimal(ix, "monqty208")
//	dw_insert.setitem(ix, "monpln_dtl_monqty08", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty108"))
//	dData = dw_insert.getitemdecimal(ix, "monqty209")
//	dw_insert.setitem(ix, "monpln_dtl_monqty09", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty109"))
//	dData = dw_insert.getitemdecimal(ix, "monqty210")
//	dw_insert.setitem(ix, "monpln_dtl_monqty10", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty110"))
////-------------------------------
//	dData = dw_insert.getitemdecimal(ix, "monqty211")
//	dw_insert.setitem(ix, "monpln_dtl_monqty11", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty111"))
//	dData = dw_insert.getitemdecimal(ix, "monqty212")
//	dw_insert.setitem(ix, "monpln_dtl_monqty12", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty112"))
//	dData = dw_insert.getitemdecimal(ix, "monqty213")
//	dw_insert.setitem(ix, "monpln_dtl_monqty13", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty113"))
//	dData = dw_insert.getitemdecimal(ix, "monqty214")
//	dw_insert.setitem(ix, "monpln_dtl_monqty14", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty114"))
//	dData = dw_insert.getitemdecimal(ix, "monqty215")
//	dw_insert.setitem(ix, "monpln_dtl_monqty15", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty115"))
//	dData = dw_insert.getitemdecimal(ix, "monqty216")
//	dw_insert.setitem(ix, "monpln_dtl_monqty16", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty116"))
//	dData = dw_insert.getitemdecimal(ix, "monqty217")
//	dw_insert.setitem(ix, "monpln_dtl_monqty17", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty117"))
//	dData = dw_insert.getitemdecimal(ix, "monqty218")
//	dw_insert.setitem(ix, "monpln_dtl_monqty18", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty118"))
//	dData = dw_insert.getitemdecimal(ix, "monqty219")
//	dw_insert.setitem(ix, "monpln_dtl_monqty19", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty119"))
//	dData = dw_insert.getitemdecimal(ix, "monqty220")
//	dw_insert.setitem(ix, "monpln_dtl_monqty20", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty120"))
////-------------------------------
//	dData = dw_insert.getitemdecimal(ix, "monqty221")
//	dw_insert.setitem(ix, "monpln_dtl_monqty21", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty121"))
//	dData = dw_insert.getitemdecimal(ix, "monqty222")
//	dw_insert.setitem(ix, "monpln_dtl_monqty22", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty122"))
//	dData = dw_insert.getitemdecimal(ix, "monqty223")
//	dw_insert.setitem(ix, "monpln_dtl_monqty23", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty123"))
//	dData = dw_insert.getitemdecimal(ix, "monqty224")
//	dw_insert.setitem(ix, "monpln_dtl_monqty24", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty124"))
//	dData = dw_insert.getitemdecimal(ix, "monqty225")
//	dw_insert.setitem(ix, "monpln_dtl_monqty25", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty125"))
//	dData = dw_insert.getitemdecimal(ix, "monqty226")
//	dw_insert.setitem(ix, "monpln_dtl_monqty26", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty126"))
//	dData = dw_insert.getitemdecimal(ix, "monqty227")
//	dw_insert.setitem(ix, "monpln_dtl_monqty27", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty127"))
//	dData = dw_insert.getitemdecimal(ix, "monqty228")
//	dw_insert.setitem(ix, "monpln_dtl_monqty28", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty128"))
//	dData = dw_insert.getitemdecimal(ix, "monqty229")
//	dw_insert.setitem(ix, "monpln_dtl_monqty29", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty129"))
//	dData = dw_insert.getitemdecimal(ix, "monqty230")
//	dw_insert.setitem(ix, "monpln_dtl_monqty30", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty130"))
//	dData = dw_insert.getitemdecimal(ix, "monqty231")
//	dw_insert.setitem(ix, "monpln_dtl_monqty31", dData + dw_insert.getitemdecimal(ix, "monpln_dtl_monqty131"))
//End If	
////=====================================================================================
//
//Return 1
end function

on w_pdt_01020.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.dw_hidden=create dw_hidden
this.dw_hist=create dw_hist
this.dw_jego=create dw_jego
this.st_2=create st_2
this.dw_jego1=create dw_jego1
this.st_3=create st_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_hidden
this.Control[iCurrent+5]=this.dw_hist
this.Control[iCurrent+6]=this.dw_jego
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_jego1
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.rr_4
end on

on w_pdt_01020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.dw_hidden)
destroy(this.dw_hist)
destroy(this.dw_jego)
destroy(this.st_2)
destroy(this.dw_jego1)
destroy(this.st_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_hist.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_hidden.SetTransObject(sqlca)

dw_jego.SetTransObject(sqlca)
dw_jego1.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)

wf_reset()


end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_01020
integer x = 32
integer y = 1072
integer width = 4562
integer height = 492
integer taborder = 20
boolean titlebar = true
string title = "일자별 상세 계획"
string dataobject = "d_pdt_01020_1"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, syymm, get_itnbr, splym, steam
integer  ireturn, iseq
long     lrow, lreturnrow
decimal  dItemPrice    //출하단가

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   		= this.getrow()
syymm  	= dw_1.getitemstring(1, 'syymm')
steam   	= dw_1.getitemstring(1, 'steam')
iseq   		= dw_1.getitemnumber(1, 'jjcha')
splym  	= this.getitemstring(lrow, 'plnyymm')

Choose 	Case	this.GetColumnName()
	Case 	"itnbr"
		sItnbr = trim(this.GetText())
	
		if	sitnbr = "" or isnull(sitnbr) then
			wf_setnull()
			return 
		end if	
		//자체 데이타 원도우에서 같은 품번을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN  1
		END IF
		//등록된 자료에서 중복 체크
	  SELECT "MONPLN_DTL"."ITNBR"  
		 INTO :get_itnbr  
		 FROM "MONPLN_DTL"  
		WHERE ( "MONPLN_DTL"."SABU" = :gs_sabu ) AND  
				( "MONPLN_DTL"."MONYYMM" = :syymm ) AND  
				( "MONPLN_DTL"."PLNYYMM" = :splym ) AND  
				( "MONPLN_DTL"."ITNBR" = :sitnbr ) AND  
				( "MONPLN_DTL"."MOSEQ" = :iseq ) AND
				( "MONPLN_DTL"."MOSEQ" = :steam );
	
		if sqlca.sqlcode <> 0 then 
			ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
			this.setitem(lrow, "itnbr", sitnbr)	
			this.setitem(lrow, "itdsc", sitdsc)	
			this.setitem(lrow, "ispec", sispec)
			IF ireturn = 0 then
//				//생산팀이 등록되였는지 체크
//				SELECT "ITEMAS"."ITNBR"  
//				  INTO :get_itnbr  
//				  FROM "ITEMAS", "ITNCT"  
//				 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
//						 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
//						 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
//						 ( "ITEMAS"."PDTGU" = :steam ) )   ;
//	
//				IF SQLCA.SQLCODE <> 0 THEN 
//					messagebox('확인', ls_text ) 
//					wf_setnull()
//					RETURN 1
//				END IF
				wf_setitem(sitnbr, syymm, iseq) //연동계획수량 및 일자별 수량 셋팅
			END IF
			RETURN ireturn
		else
			f_message_chk(37,'[품번]') 
			wf_setnull()
			RETURN 1
		end if	
	Case 	"itdsc"	
		sItdsc = trim(this.GetText())
		if sitdsc = "" or isnull(sitdsc) then
			wf_setnull()
			return 
		end if	
	
		ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)
		if ireturn = 0 then 
			//자체 데이타 원도우에서 같은 품번을 체크
			lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
			IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[품번]') 
				wf_setnull()
				RETURN  1
			END IF
			
			//등록된 자료에서 체크
		  SELECT "MONPLN_DTL"."ITNBR"  
			 INTO :get_itnbr  
			 FROM "MONPLN_DTL"  
			WHERE ( "MONPLN_DTL"."SABU" = :gs_sabu ) AND  
					( "MONPLN_DTL"."MONYYMM" = :syymm ) AND  
					( "MONPLN_DTL"."PLNYYMM" = :splym ) AND  
					( "MONPLN_DTL"."ITNBR" = :sitnbr ) AND  
					( "MONPLN_DTL"."MOSEQ" = :iseq )   ;
		
			if sqlca.sqlcode = 0 then 
				f_message_chk(37,'[품번]') 
				wf_setnull()
				RETURN 1
			else
//				//생산팀이 등록되였는지 체크
//				SELECT "ITEMAS"."ITNBR"  
//				  INTO :get_itnbr  
//				  FROM "ITEMAS", "ITNCT"  
//				 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
//						 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
//						 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
//						 ( "ITEMAS"."PDTGU" = :steam ) )   ;
//	
//				IF SQLCA.SQLCODE <> 0 THEN 
//					messagebox('확인', ls_text ) 
//					wf_setnull()
//					RETURN 1
//				END IF
				wf_setitem(sitnbr, syymm, iseq) //연동계획수량 및 일자별 수량 셋팅
			end if	
		end if		
		RETURN ireturn
	Case "ispec"	
		sIspec = trim(this.GetText())
		if sispec = "" or isnull(sispec) then
			wf_setnull()
			return 
		end if	
	
		ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)
		if ireturn = 0 then 
			//자체 데이타 원도우에서 같은 품번을 체크
			lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
			IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[품번]') 
				wf_setnull()
				RETURN  1
			END IF
	
			//등록된 자료에서 체크
		  SELECT "MONPLN_DTL"."ITNBR"  
			 INTO :get_itnbr  
			 FROM "MONPLN_DTL"  
			WHERE ( "MONPLN_DTL"."SABU" = :gs_sabu ) AND  
					( "MONPLN_DTL"."MONYYMM" = :syymm ) AND  
					( "MONPLN_DTL"."PLNYYMM" = :splym ) AND  
					( "MONPLN_DTL"."ITNBR" = :sitnbr ) AND  
					( "MONPLN_DTL"."MOSEQ" = :iseq )   ;
		
			if 	sqlca.sqlcode = 0 then 
				f_message_chk(37,'[품번]') 
				wf_setnull()
				RETURN 1
			else
//				//생산팀이 등록되였는지 체크
//				SELECT "ITEMAS"."ITNBR"  
//				  INTO :get_itnbr  
//				  FROM "ITEMAS", "ITNCT"  
//				 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
//						 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
//						 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
//						 ( "ITEMAS"."PDTGU" = :steam ) )   ;
//	
//				IF SQLCA.SQLCODE <> 0 THEN 
//					messagebox('확인', ls_text ) 
//					wf_setnull()
//					RETURN 1
//				END IF
				wf_setitem(sitnbr, syymm, iseq) //연동계획수량 및 일자별 수량 셋팅
			end if	
		end if		
		RETURN ireturn
END Choose



////==============================================================================//

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
END IF
end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::editchanged;call super::editchanged;String scol_name
Dec {2} dData, dData2

sCol_name = dwo.name
Choose Case scol_Name
		 Case 'monqty101'
				dData = Dec(this.gettext()) + this.getitemdecimal(row, "monpln_dtl_monqty201")
			   this.setitem(row, "monpln_dtl_monqty01", dData )
		 Case 'monqty201'
				dData = Dec(gettext())
			   this.setitem(row, "monpln_dtl_monqty01", dData + getitemdecimal(row, "monpln_dtl_monqty101"))
		 Case 'monqty102'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty02", dData + getitemdecimal(row, "monpln_dtl_monqty202"))
		 Case 'monqty202'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty02", dData + getitemdecimal(row, "monpln_dtl_monqty102"))
		 Case 'monqty103'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty03", dData + getitemdecimal(row, "monpln_dtl_monqty203"))
		 Case 'monqty203'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty03", dData + getitemdecimal(row, "monpln_dtl_monqty103"))				
		 Case 'monqty104'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty04", dData + getitemdecimal(row, "monpln_dtl_monqty204"))
		 Case 'monqty204'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty04", dData + getitemdecimal(row, "monpln_dtl_monqty104"))
		 Case 'monqty105'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty05", dData + getitemdecimal(row, "monpln_dtl_monqty205"))
		 Case 'monqty205'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty05", dData + getitemdecimal(row, "monpln_dtl_monqty105"))
//---------------------------------------------------------------------------------------------
		Case 'monqty106'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty06", dData + getitemdecimal(row, "monpln_dtl_monqty206"))
		 Case 'monqty206'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty06", dData + getitemdecimal(row, "monpln_dtl_monqty106"))
		 Case 'monqty107'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty07", dData + getitemdecimal(row, "monpln_dtl_monqty207"))
		 Case 'monqty207'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty07", dData + getitemdecimal(row, "monpln_dtl_monqty107"))
		 Case 'monqty108'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty08", dData + getitemdecimal(row, "monpln_dtl_monqty208"))
		 Case 'monqty208'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty08", dData + getitemdecimal(row, "monpln_dtl_monqty108"))
		 Case 'monqty109'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty09", dData + getitemdecimal(row, "monpln_dtl_monqty209"))
		 Case 'monqty209'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty09", dData + getitemdecimal(row, "monpln_dtl_monqty109"))
		 Case 'monqty110'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty10", dData + getitemdecimal(row, "monpln_dtl_monqty210"))
		 Case 'monqty210'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty10", dData + getitemdecimal(row, "monpln_dtl_monqty110"))
//-------------------------------
		Case 'monqty111'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty11", dData + getitemdecimal(row, "monpln_dtl_monqty211"))
		 Case 'monqty211'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty11", dData + getitemdecimal(row, "monpln_dtl_monqty111"))
		 Case 'monqty112'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty12", dData + getitemdecimal(row, "monpln_dtl_monqty212"))
		 Case 'monqty212'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty12", dData + getitemdecimal(row, "monpln_dtl_monqty112"))
		 Case 'monqty113'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty13", dData + getitemdecimal(row, "monpln_dtl_monqty213"))
		 Case 'monqty213'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty13", dData + getitemdecimal(row, "monpln_dtl_monqty113"))
		 Case 'monqty114'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty14", dData + getitemdecimal(row, "monpln_dtl_monqty214"))
		 Case 'monqty214'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty14", dData + getitemdecimal(row, "monpln_dtl_monqty114"))
		 Case 'monqty115'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty15", dData + getitemdecimal(row, "monpln_dtl_monqty215"))
		 Case 'monqty215'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty15", dData + getitemdecimal(row, "monpln_dtl_monqty115"))
		 Case 'monqty116'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty16", dData + getitemdecimal(row, "monpln_dtl_monqty216"))
		 Case 'monqty216'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty16", dData + getitemdecimal(row, "monpln_dtl_monqty116"))
		 Case 'monqty117'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty17", dData + getitemdecimal(row, "monpln_dtl_monqty217"))
		 Case 'monqty217'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty17", dData + getitemdecimal(row, "monpln_dtl_monqty117"))
		 Case 'monqty118'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty18", dData + getitemdecimal(row, "monpln_dtl_monqty218"))
		 Case 'monqty218'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty18", dData + getitemdecimal(row, "monpln_dtl_monqty118"))
		 Case 'monqty119'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty19", dData + getitemdecimal(row, "monpln_dtl_monqty219"))
		 Case 'monqty219'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty19", dData + getitemdecimal(row, "monpln_dtl_monqty119"))
		 Case 'monqty120'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty20", dData + getitemdecimal(row, "monpln_dtl_monqty220"))
		 Case 'monqty220'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty20", dData + getitemdecimal(row, "monpln_dtl_monqty120"))
//-------------------------------
		 Case 'monqty121'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty21", dData + getitemdecimal(row, "monpln_dtl_monqty221"))
		 Case 'monqty221'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty21", dData + getitemdecimal(row, "monpln_dtl_monqty121"))
		 Case 'monqty122'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty22", dData + getitemdecimal(row, "monpln_dtl_monqty222"))
		 Case 'monqty222'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty22", dData + getitemdecimal(row, "monpln_dtl_monqty122"))
		 Case 'monqty123'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty23", dData + getitemdecimal(row, "monpln_dtl_monqty223"))
		 Case 'monqty223'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty23", dData + getitemdecimal(row, "monpln_dtl_monqty123"))
		 Case 'monqty124'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty24", dData + getitemdecimal(row, "monpln_dtl_monqty224"))
		 Case 'monqty224'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty24", dData + getitemdecimal(row, "monpln_dtl_monqty124"))
		 Case 'monqty125'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty25", dData + getitemdecimal(row, "monpln_dtl_monqty225"))
		 Case 'monqty225'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty25", dData + getitemdecimal(row, "monpln_dtl_monqty125"))
		 Case 'monqty126'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty26", dData + getitemdecimal(row, "monpln_dtl_monqty226"))
		 Case 'monqty226'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty26", dData + getitemdecimal(row, "monpln_dtl_monqty126"))
		 Case 'monqty127'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty27", dData + getitemdecimal(row, "monpln_dtl_monqty227"))
		 Case 'monqty227'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty27", dData + getitemdecimal(row, "monpln_dtl_monqty127"))
		 Case 'monqty128'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty28", dData + getitemdecimal(row, "monpln_dtl_monqty228"))
		 Case 'monqty228'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty28", dData + getitemdecimal(row, "monpln_dtl_monqty128"))
		 Case 'monqty129'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty29", dData + getitemdecimal(row, "monpln_dtl_monqty229"))
		 Case 'monqty229'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty29", dData + getitemdecimal(row, "monpln_dtl_monqty129"))
		 Case 'monqty130'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty30", dData + getitemdecimal(row, "monpln_dtl_monqty230"))
		 Case 'monqty230'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty30", dData + getitemdecimal(row, "monpln_dtl_monqty130"))
		 Case 'monqty131'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty31", dData + getitemdecimal(row, "monpln_dtl_monqty231"))
		 Case 'monqty231'
				dData = Dec(gettext())
			   setitem(row, "monpln_dtl_monqty31", dData + getitemdecimal(row, "monpln_dtl_monqty131"))
End choose


end event

type p_delrow from w_inherite`p_delrow within w_pdt_01020
integer x = 3918
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

event p_delrow::clicked;call super::clicked;Integer i, irow, irow2, i_seq
string s_yymm, s_toym, sitnbr, s_plym
Long Lrow 

if dw_1.AcceptText() = -1 then return 

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then return 	

Lrow = dw_insert.getrow()
If Lrow < 1 then return

s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
sitnbr = dw_insert.getitemstring(1, "itnbr")
s_plym = dw_insert.getitemstring(1, "plnyymm")

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 삭제할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	
	// 외주계획도 동시에 삭제한다.
	Delete
	  From monpln_out
	 Where sabu  = :gs_sabu and monyymm = :s_yymm and plnyymm = :s_plym
	 	and moseq = :i_seq   and itnbr   = :sitnbr;
	
	if sqlca.sqlcode <> 0  then
		rollback ;
	   messagebox("저장실패", "월 외주계획자료에 대한 갱신이 실패하였읍니다")		
	End if
	
	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "월 생산계획자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_pdt_01020
integer x = 3744
boolean enabled = false
string picturename = "C:\erpman\image\행추가_d.gif"
end type

event p_addrow::clicked;call super::clicked;string s_team, s_yymm, s_plym, s_toym
Int    i_seq, i_plym
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_team = dw_1.GetItemString(1,'steam')
i_plym  = dw_1.GetItemNumber(1,'plan_ym')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 추가할 수 없습니다!!")

	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

if isnull(i_plym) then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('plan_ym')
	dw_1.SetFocus()
	return
else
	s_plym = f_aftermonth(s_yymm, i_plym)   //기준년월에 계획년월을 더하여 실제 계획년월을...
end if	

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

dw_insert.SetRedraw(false)

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'monyymm', s_yymm )
dw_insert.setitem(il_currow, 'plnyymm', s_plym )
dw_insert.setitem(il_currow, 'moseq', i_seq )
dw_insert.setitem(il_currow, 'pdtgu', s_team )

dw_insert.ScrollToRow(il_currow)
//======= 기존--- 값들을 Clear.
wf_setnull()
//--------------------------

//dw_insert.Modify("DataWindow.HorizontalScrollPosition='1'")

dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_insert.SetRedraw(true)
ib_any_typing =True
dw_1.enabled = false

p_search.enabled = false
p_search.PictureName = 'C:\erpman\image\생성_d.gif'

end event

type p_search from w_inherite`p_search within w_pdt_01020
integer x = 3136
integer y = 32
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttonup;call super::ue_lbuttonup;p_search.picturename = 'C:\erpman\image\생성_up.gif'
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;p_search.picturename = 'C:\erpman\image\생성_dn.gif'
end event

event p_search::clicked;call super::clicked;/* MRP Server procedure 를 실행
   step마다 error check를 실행하여 error가 발생할 경우 해당시점에서
	중단 */
String sgijun, sgyymm, serror, smsgtxt, scalgu, sTxt, sstdat, seddat, scheck, sLoop, ssaupj, sPdtgu, spdupt
String temp_calgu
integer dseq, dCnt, dMaxno, dAddNo, icnt

sgijun = '6' // 월계획자료를 반제품계획으로 전개
sgyymm = trim(dw_1.object.syymm[1])
dseq   = dw_1.object.jjcha[1]
scalgu = '2'														 // factor적용
sstdat = f_today()												 //시작일자
seddat = f_last_date(f_aftermonth(left(sstdat, 6), 4)) // 종료일자
spdtgu   = dw_1.object.steam[1]

ssaupj  = gs_saupj

if isnull(sgyymm) or sgyymm = "" then
	f_message_chk(30,'[계획년월]')
	return
end if

if isnull(spdtgu) or spdtgu = "" then
	f_message_chk(30,'[생산팀]')
	return
end if

smsgtxt = left(sgyymm ,4)+ '년 ' + right(sgyymm,2) + '월 ' + '소요량 전개(MRP)처리를 하시겠습니까?'
smsgtxt = smsgtxt + ( "~r~n" + "재고감안   Yes" )
smsgtxt = smsgtxt + ( "~r~n" + "재고미감안 No" )
smsgtxt = smsgtxt + ( "~r~n" + "취소       Cancel" )
Choose Case messagebox("확 인", smsgtxt, Question!, YesNoCancel!, 3)
	Case 1
		sCalgu = '1'		// factor 감안
	Case 2
		sCalgu = '2'		// factor 미감안
	Case 3
		return
End Choose

sLoop = 'N'

setpointer(hourglass!)

serror = 'X'
icnt = 0

// Mrp History Create
/* MRP실행이력의 최대 실행순번을 구한다 */
SELECT MAX(ACTNO)	
  INTO :dmaxno
  FROM MRPSYS
 WHERE SABU = :gs_sabu;

if isnull(dmaxno) then dmaxno = 0;

dMaxno = dmaxno + 1

IF sCalgu = '1' THEN
	sTXT	= 'FACTOR적용';
ELSEIF sCalgu = '2' THEN
	sTXT  = 'FACTOR적용안함';
ELSE
	sTXT  = 'FACTOR적용+적용안함';
END IF;


/* MRP이력을 작성한다 */
INSERT INTO MRPSYS (SABU, ACTNO, MRPRUN, MRPGIYYMM, MRPDATA, MRPCUDAT, MRPSIDAT,
						  MRPEDDAT, MRPTXT, MRPSEQ, MRPCALGU, MRPPDTSND, MRPMATSND, MRPDELETE, SAUPJ)
		VALUES(:gs_sabu, :dMAXNO, TO_CHAR(SYSDATE, 'YYYYMMDD'), :sGyymm, :sgijun,
				 TO_CHAR(SYSDATE, 'YYYYMMDD'), :sstdat, :seddat, :stxt, :dseq, 'N','N','N','N', :ssaupj);
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp History Create]' + '~n' + sqlca.sqlerrtext)
	return
END If

COMMIT;

if sLoop = 'N' then
	// Factor적용시 계산한 적용창고를 Copy
	insert into mrpsys_depot
		Select :gs_sabu, :dMaxno, cvcod
		  From vndmst
		 Where cvgu = '5' And ipjogun = :gs_saupj;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		sle_msg.text = ""
		f_message_chk(41,'[적용 창고 복사]' + '~n' + sqlca.sqlerrtext)
		return
	END If
	// Factor적용시 계산한 생산팀을 Copy
	insert into mrpsys_dtl ( sabu, actno, dptgu )
	  values (:gs_sabu, :dmaxno, :spdtgu);
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		sle_msg.text = ""
		f_message_chk(41,'[적용 생산팀 복사]' + '~n' + sqlca.sqlerrtext)
		return
	END If
	
	COMMIT;
end if

w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. .............."

String ssilgu
ssilgu = f_get_syscnfg('S', 8, '40')

// mrp initial
w_mdi_frame.sle_msg.text =  "자재 소요량 전개(MRP)처리중. .............." + "MRP Initial Create"

sqlca.erp100000050_1(gs_sabu, dmaxno, sgijun, sgyymm, dseq, spdtgu, ssilgu, serror); 
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp Initial]' + '~n' + sqlca.sqlerrtext)
	return
END IF


// open order merge
icnt = 0
w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. ..............Open Order Merge"

IF SCALGU = '1' THEN /* FACTOR를 적용하는 경우에만 생성 */
	sqlca.erp100000050_2(gs_sabu, dmaxno, sgijun, serror);
	If isnull(serror) or serror = 'X' or serror = 'Y' then
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(41,'[MRP RUN-Open Order Merge]'+ '~n' + sqlca.sqlerrtext)
		return
	END IF
END IF

// product schedule
icnt = 0
w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. ..............Open Product Schedule"
serror = 'X'
sqlca.erp100000050_3(gs_sabu, dmaxno, sgijun, sgyymm, dseq, spdtgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN- Product Schedule]'+ '~n' + sqlca.sqlerrtext)
	return
END IF

// manufacturing resource create
icnt = 0
w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. ..............Manufacturing Resource Create"

sqlca.erp100000050_4(gs_sabu, dmaxno, sgijun, sgyymm, scalgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Manufacturing Resource Create]'+ '~n' + sqlca.sqlerrtext)
	return
END IF

// mrp detail record create
icnt = 0
w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. ..............MRP Detail Record Create"

sqlca.erp000000050_5(gs_sabu, dmaxno, sgijun, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp Detail Record Create]'+ '~n' + sqlca.sqlerrtext)
	return
END IF

// plan detail record create
icnt = 0
w_mdi_frame.sle_msg.text = "자재 소요량 전개(MRP)처리중. ..............Plan Detail Record Create"

sqlca.erp000000050_6(gs_sabu, dmaxno, sgijun, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Plan Detail Record Create]'+ '~n' + sqlca.sqlerrtext)
	return
END IF

/* MRP계산이 정상적으로 종료되었다는 표시를 한다 */
Update mrpsys
   set mrpcalgu = 'Y'
 Where sabu = :gs_sabu and actno = :dmaxno;

If sqlca.sqlcode <> 0 then
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[계산이력 작성중 오류발생]'+ '~n' + sqlca.sqlerrtext)
	return
END If 

Update reffpf
   set rfna2 = to_char(:dmaxno)
 where sabu = '1' and rfcod = '1A' and rfgub = '1';

COMMIT;

/////////////////////////////////

w_mdi_frame.sle_msg.text ='자료를 확정중입니다'
serror = 'X'
spdupt = 'Y'
Sqlca.erp000000050_7(gs_sabu, dmaxno, sgyymm, dseq, sgijun, spdupt, 'N', 'N', serror)
//messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
Commit;							

IF serror <> 'N' THEN
	messagebox("확 인", "계획ORDER1 확정이 실패하였습니다.!!")
else
	//messagebox("확 인", "계획ORDER1 확정이 되었읍니다.!!")
	messagebox("반제품 소요량 계산", "실행번호 -> " + string(dmaxno) + " 로 정상종료되었읍니다")	
	// 생산계획 전송인 경우 참조코드(04-2)에 실행순번을 저장
	if spdupt = 'Y' then
		Update reffpf
			Set rfna2 = to_char(:dmaxno)
		 Where sabu = '1' and rfcod = '1A' and rfgub = '2';
		if sqlca.sqlcode <> 0 then		 
			Messagebox("참조코드오류", sqlca.sqlerrtext)
		end if		 
	End if
	
	Commit;	
END IF

w_mdi_frame.sle_msg.text = ""

end event

type p_ins from w_inherite`p_ins within w_pdt_01020
boolean visible = false
integer x = 3241
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_01020
end type

type p_can from w_inherite`p_can within w_pdt_01020
end type

event p_can::clicked;call super::clicked;wf_reset()

dw_1.enabled = true
p_search.enabled = true
p_search.PictureName = 'C:\erpman\image\생성_up.gif'

ib_any_typing = FALSE

p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
p_addrow.enabled = false
p_delrow.enabled = false
p_mod.enabled = false

dw_1.setfocus()

end event

type p_print from w_inherite`p_print within w_pdt_01020
boolean visible = false
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_01020
integer x = 3570
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_plym, s_lastday, snaewi, spangbn
Int    i_seq, i_plym
Long lrow

if dw_1.AcceptText() = -1 then return 

s_gub  = dw_1.GetItemString(1,'sgub')
s_team = dw_1.GetItemString(1,'steam')
snaewi = dw_1.GetItemString(1,'naewi')
spangbn= dw_1.GetItemString(1,'pangbn')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
i_plym  = dw_1.GetItemNumber(1,'plan_ym')

If Isnull(spangbn) Then spangbn = ''

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

if isnull(i_plym) then
	f_message_chk(30,'[계획년월]')
	dw_1.Setcolumn('plan_ym')
	dw_1.SetFocus()
	return
else
	s_plym = f_aftermonth(s_yymm, i_plym)   //기준년월에 계획년월을 더하여 실제 계획년월을...
end if	

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

If s_gub = '0' then //품목분류로 조회
   s_ittyp   = dw_1.GetItemString(1,'sittyp')
	if isnull(s_ittyp) or s_ittyp = "" then
		f_message_chk(30,'[품목구분]')
		dw_1.Setcolumn('sittyp')
		dw_1.SetFocus()
		return
	end if	
   s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
	if isnull(s_fritcls) or s_fritcls = "" then
      s_fritcls = '.'
   end if	
   s_toitcls = trim(dw_1.GetItemString(1,'to_itcls'))
	if isnull(s_toitcls) or s_toitcls = "" then
      s_toitcls = 'zzzzzzz'
   end if	
   if s_fritcls > s_toitcls then 
		f_message_chk(34,'[품목분류]')
		dw_1.Setcolumn('fr_itcls')
		dw_1.SetFocus()
		return
	end if
	
	//계획년월에 마지막일자를 가져오기
	s_lastday = right(f_last_date(s_plym), 2)
	if dw_insert.Retrieve(gs_sabu,s_team,s_yymm,i_seq,s_plym, i_plym, s_lastday, &
								 s_ittyp,s_fritcls,s_toitcls) <= 0 then 
	   f_message_chk(50,'')
		dw_1.SetFocus()
		p_addrow.enabled = true
		p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
		
		p_delrow.enabled = true
		p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
		
		p_mod.enabled = true
		p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
		return
	end if	
Else   //품번으로 조회
	s_ittyp   = dw_1.GetItemString(1,'sittyp')
	if isnull(s_ittyp) or s_ittyp = "" then s_ittyp = ''

   s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
	if isnull(s_fritcls) or s_fritcls = "" then s_fritcls = ''
		
   s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
	if isnull(s_fritnbr) or s_fritnbr = "" then
      s_fritnbr = '.'
   end if	
   s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))
	if isnull(s_toitnbr) or s_toitnbr = "" then
      s_toitnbr = 'zzzzzzzzzzzzzzz'
   end if	
   if s_fritnbr > s_toitnbr then 
		f_message_chk(34,'[품번]')
		dw_1.Setcolumn('fr_itnbr')
		dw_1.SetFocus()
		return
	end if	

	// 집계내역 조회
	If dw_hist.Retrieve(gs_sabu,s_team,s_yymm,i_seq,s_fritnbr,s_toitnbr,gs_saupj, 5000000, sPangbn+'%', s_ittyp+'%',s_fritcls+'%') <= 0 then
		f_message_chk(50,'')

		dw_insert.Reset()
		dw_1.SetFocus()
		p_addrow.enabled = true
		p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
		p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
		p_delrow.enabled = true
		p_mod.enabled = true
		p_mod.PictureName = 'C:\erpman\image\저장_up.gif'		
		Return
	End If
	
	dw_insert.SetFilter("itnbr = ''")
	dw_insert.Filter()
	
	//계획년월에 마지막일자를 가져오기
	s_lastday = right(f_last_date(s_plym), 2)
	dw_insert.Retrieve(gs_sabu,s_team,s_yymm,i_seq,s_plym, i_plym, s_lastday, s_fritnbr,s_toitnbr)
End if	

dw_insert.SetFocus()
//dw_1.enabled = false
ib_any_typing = FALSE

// 일별 생산계획이 생성이 되어 있으면 외주계획은 외주에서 수립함
if snaewi = '2' then
	Lrow = 0
	SELECT COUNT(*) INTO :LROW
	 FROM "MONPLN_OUT"  
	WHERE ( "MONPLN_OUT"."SABU" = :gs_sabu ) AND  
			( "MONPLN_OUT"."MONYYMM" = :s_yymm ) AND  
			( "MONPLN_OUT"."PLNYYMM" = :s_plym ) AND  
			( "MONPLN_OUT"."MOSEQ" = :i_seq ) ;
	If sqlca.sqlcode <> 0  or Lrow > 0 then
		MessageBox("월 외주계획", "외주계획이 이미 작성되었읍니다" + '~n' + &
										  "외주는 외주에서 작성하십시요", stopsign!)
		return
	End if
End if

p_search.enabled = false
p_addrow.enabled = true
p_delrow.enabled = true
p_mod.enabled 	  = true
p_search.PictureName = 'C:\erpman\image\생성_d.gif'
p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
p_mod.PictureName = 'C:\erpman\image\저장_up.gif'

end event

type p_del from w_inherite`p_del within w_pdt_01020
integer x = 3314
integer y = 32
end type

event p_del::clicked;call super::clicked;string s_yymm, s_toym, s_pdtgu, smsgtxt
int    i_seq

if dw_1.AcceptText() = -1 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))
s_pdtgu = trim(dw_1.GetItemString(1,'steam'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

if isnull(s_pdtgu) or s_pdtgu = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")

	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

//gs_code = s_yymm
//gs_codename = string(i_seq) 
//Open(w_pdt_01022)

smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' &
			 + '생산계획을 삭제 하시겠습니까?'
if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   

SetPointer(HourGlass!)
	
DELETE FROM MONPLN_DTL
 WHERE SABU = :gs_sabu AND MONYYMM = :s_yymm AND MOSEQ = :i_seq
   AND PDTGU = :s_pdtgu;
//		 ITNBR IN ( SELECT B.ITNBR  FROM  ITEMAS B WHERE B.PDTGU = :s_pdtgu  )   ;
									 
IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK;
   messagebox("삭제실패", "삭제가 실패하였읍니다")
	return 
end if

DELETE FROM MONPLN_SUM
 WHERE SABU = :gs_sabu AND MONYYMM = :s_yymm AND MOSEQ = :i_seq
   AND PDTGU = :s_pdtgu;
									 
IF SQLCA.SQLCODE = 0 THEN
	COMMIT;
	messagebox("삭제", "자료가 삭제되었습니다!!")
	wf_reset()
else
	ROLLBACK;
   messagebox("삭제실패", "삭제가 실패하였읍니다")
	return 
end if

end event

type p_mod from w_inherite`p_mod within w_pdt_01020
integer x = 4091
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;string s_yymm, s_toym
long   i

if dw_1.AcceptText() = -1 then return 

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("확인", "현재 이전 년월 자료는 저장할 수 없습니다!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_01020
integer x = 3831
integer y = 2512
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_pdt_01020
integer x = 2181
integer y = 2544
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_pdt_01020
integer x = 1422
integer y = 2544
integer taborder = 60
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_01020
integer x = 2533
integer y = 2544
integer taborder = 80
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_01020
integer x = 1070
integer y = 2544
end type

type cb_print from w_inherite`cb_print within w_pdt_01020
integer x = 590
integer y = 2544
integer width = 462
integer taborder = 40
string text = "삭제처리"
end type

type st_1 from w_inherite`st_1 within w_pdt_01020
end type

type cb_can from w_inherite`cb_can within w_pdt_01020
integer x = 3387
integer y = 2528
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_pdt_01020
integer x = 110
integer y = 2544
integer width = 462
integer taborder = 30
string text = "월생산계획"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_01020
integer x = 9
integer y = 2580
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_01020
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_01020
end type

type gb_3 from groupbox within w_pdt_01020
boolean visible = false
integer x = 2135
integer y = 2484
integer width = 1481
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdt_01020
boolean visible = false
integer x = 64
integer y = 2484
integer width = 1733
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_pdt_01020
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 8
integer width = 3081
integer height = 212
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_01020_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;IF this.GetColumnName() ="sgub" THEN RETURN

Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "fr_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"fr_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "to_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"to_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "fr_itcls" Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return 
			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
					 str_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
				this.SetItem(1,"fr_itcls", str_sitnct.s_sumgub)
				RETURN 1
 			else
				f_message_chk(61,'[품목구분]')
				return 1
			end if	
		ELSEIF This.GetColumnName() = "to_itcls" Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return 
			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
					 str_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
				this.SetItem(1,"to_itcls", str_sitnct.s_sumgub)
	   		RETURN 1
 			else
				f_message_chk(61,'[품목구분]')
				return 1
			end if	
      End If
END IF

end event

event itemchanged;string snull, syymm, s_name, s_itt, s_curym, s_gub,steam, steamnm, stitnm, stextnm
int    iseq, inull, get_yeacha, i

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="steam" THEN
	steam = trim(this.GetText())
	setnull(ls_text)
	
	if dw_hidden.retrieve(steam) < 1 then
		messagebox("확인", '생산팀에 품목이 존재하지 않습니다. 생산팀을 확인하세요!')
		this.setitem(1, 'steam', snull)
		return 1 
	else
		steamnm = dw_hidden.getitemstring(1, 'teamnm')
	   FOR i=1 TO dw_hidden.rowcount()
			 stitnm  = dw_hidden.getitemstring(i, 'titnm')
          if i = 1 then
   			 stextnm = stitnm
			 else
				 stextnm = stextnm + ',' + '~n' + stitnm
 	 		 end if	 
		NEXT
      ls_text =  '생산팀 ' + steamnm + ' 는(은) ' + '대분류가 ' + '~n' &
		           + stextnm + ' 인' + '~n' + '품목만 입력가능합니다.'
   end if
ELSEIF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then
  		this.setitem(1, 'jjcha', 1)
		return 
	end if	

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[계획년월]')
		this.setitem(1, "syymm", sNull)
  		this.setitem(1, 'jjcha', 1)
		return 1
	END IF
	
	s_curym = left(f_today(), 6)
	
	SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
	  FROM "MONPLN_SUM"  
	 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

	if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

	dw_1.setitem(1, 'jjcha', get_yeacha )
ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq  = integer(this.gettext())
   syymm = trim(this.getitemstring(1, 'syymm'))
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syymm = "" or isnull(syymm) then 
		messagebox("확인", "계획년월을 먼저 입력 하십시요!!")
  		this.setitem(1, 'jjcha', inull)
		this.setcolumn('syymm')
		this.setfocus()
		return 1
	end if		
   SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
     FROM "MONPLN_SUM"  
    WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;
   
	//확정계획이 없는 경우 조정계획을 입력할 수 없고
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("확인", left(syymm,4)+"년 "+mid(syymm,5,2)+"월에 확정/조정계획이 없으니 " &
			                   + "확정만 입력가능합니다!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	//조정계획이 있는 경우 확정계획을 입력할 수 없다.	
	elseif get_yeacha = 2 then
		if iseq = 1 then
   		messagebox("확인", left(syymm,4)+"년 "+mid(syymm,5,2)+"월에 조정계획이 있으니 " &
			                   + "확정은 입력할 수 없습니다!!")
	  		this.setitem(1, 'jjcha', 2)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
		end if		
   end if		
ELSEIF this.GetColumnName() = 'sittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   ELSEIF s_itt = '1' or s_itt = '2' or s_itt = '7' THEN //1완제품, 2반제품, 7상품  
   ELSE 	
		f_message_chk(61,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   END IF
	/* 품목분류 */
ELSEIF this.GetColumnName() = 'fr_itcls' THEN
		SetItem(1,'fr_titnm',sNull)
		
		s_gub = Trim(GetText())
		IF s_gub = "" OR IsNull(s_gub) THEN 		RETURN
		
		s_itt = GetItemString(1,"sittyp")
		If IsNull(s_itt) Or s_itt = '' then s_itt = '1'
		
		IF s_itt <> "" AND Not IsNull(s_itt) THEN 
			SELECT "ITNCT"."TITNM"
			  INTO :stitnm
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND ( "ITNCT"."ITCLS" = :s_gub );
			
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"fr_titnm",stitnm)
			END IF
		END IF
ELSEIF this.GetColumnName() = 'sgub' THEN   // 품목분류, 품번
	s_gub = this.gettext()
    	
	wf_modify(s_gub)
	
ELSEIF this.GetColumnName() = 'naewi' THEN
	s_gub = this.gettext()
    	
	wf_modify1(s_gub)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string snull, sname
str_itnct lstr_sitnct

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'fr_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fr_itcls", lstr_sitnct.s_sumgub)
		this.SetItem(1,"fr_titnm", lstr_sitnct.s_titnm)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
elseif this.GetColumnName() = 'to_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '7' THEN //1완제품, 2반제품, 7상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"to_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
end if	

end event

event losefocus;//this.accepttext()
end event

type dw_hidden from datawindow within w_pdt_01020
boolean visible = false
integer x = 997
integer y = 2384
integer width = 494
integer height = 360
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_pdt_01000_9"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_hist from u_key_enter within w_pdt_01020
integer x = 32
integer y = 236
integer width = 4562
integer height = 824
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_01020_3"
boolean border = false
end type

event clicked;call super::clicked;String sItnbr

If row <= 0 Then 
	SelectRow(0,false)
	sItnbr = ''
Else
	SelectRow(0,false)
	SelectRow(row,true)
	sItnbr = GetItemString(row, 'itnbr')
End If

dw_insert.SetFilter("itnbr = '" + sItnbr + "'")
dw_insert.Filter()

// 소요자재현황 조회
dw_jego.Retrieve(sItnbr, gs_saupj)
dw_jego1.Reset()
end event

type dw_jego from datawindow within w_pdt_01020
integer x = 27
integer y = 1644
integer width = 2341
integer height = 644
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_01020_jego"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Decimal {3} dJego
String sItnbr
Long   ix

If row <= 0 Then
	dw_jego1.Reset()
Else
	sItnbr = GetITemString(row, 'stock_itnbr')
	
	dJego = 0
	For ix = 1 To RowCount()
		If GetITemString(ix, 'soname') = '10' Then
			dJego = getitemdecimal(ix, "compute_0003")
			Exit
		End If
	Next
End If

dw_jego1.retrieve(gs_sabu, sItnbr, dJego)
end event

type st_2 from statictext within w_pdt_01020
integer x = 41
integer y = 1580
integer width = 535
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[소요자재 재고현황]"
boolean focusrectangle = false
end type

type dw_jego1 from datawindow within w_pdt_01020
integer x = 2368
integer y = 1644
integer width = 2217
integer height = 644
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_01020_jego1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_pdt_01020
integer x = 2373
integer y = 1580
integer width = 480
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "[입출고 예정현황]"
boolean focusrectangle = false
end type

type rr_4 from roundrectangle within w_pdt_01020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 228
integer width = 4590
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_pdm_01530.srw
$PBExportComments$생산bom등록
forward
global type w_pdm_01530 from w_inherite
end type
type dw_head from u_key_enter within w_pdm_01530
end type
type tv_1 from treeview within w_pdm_01530
end type
type st_splitbar from u_st_splitbar within w_pdm_01530
end type
type cbx_1 from checkbox within w_pdm_01530
end type
type p_1 from uo_picture within w_pdm_01530
end type
type p_2 from uo_picture within w_pdm_01530
end type
type p_3 from uo_picture within w_pdm_01530
end type
type p_4 from uo_picture within w_pdm_01530
end type
type p_5 from uo_picture within w_pdm_01530
end type
type p_6 from uo_picture within w_pdm_01530
end type
type cb_ys from commandbutton within w_pdm_01530
end type
type p_7 from uo_picture within w_pdm_01530
end type
type cbx_2 from checkbox within w_pdm_01530
end type
type rr_2 from roundrectangle within w_pdm_01530
end type
type rr_1 from roundrectangle within w_pdm_01530
end type
end forward

global type w_pdm_01530 from w_inherite
string tag = "생산/외주 BOM 등록"
integer width = 4654
integer height = 2512
string title = "생산/외주 BOM 등록"
dw_head dw_head
tv_1 tv_1
st_splitbar st_splitbar
cbx_1 cbx_1
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
p_5 p_5
p_6 p_6
cb_ys cb_ys
p_7 p_7
cbx_2 cbx_2
rr_2 rr_2
rr_1 rr_1
end type
global w_pdm_01530 w_pdm_01530

type variables
Long il_dragsource, il_droptarget, il_prvtarget, il_dragparent, il_crttree
String iSlabel[], iSdata[]
Integer iIpic[], iISel[], iIlevel[], Iicnt
Boolean iBchild[], iBflash
Str_pstruc pstruc_str
String is_masterno   // 현재품목의 상위품번
end variables

forward prototypes
public subroutine wf_treeview (string sitem)
public subroutine wf_treeview_delete ()
public function integer wf_treeview_seek (treeview ltvi, long ahandle, string old_pinbr, string old_usseq, string new_pinbr, string new_cinbr, string arg_cinbr)
public function integer wf_update (string old_pinbr, string old_usseq, string new_pinbr, ref string new_usseq, string arg_cinbr)
public function integer wf_estupdate ()
public subroutine wf_treeview_make (treeview ltvi, long ahandle)
public function integer wf_refresh ()
public function integer wf_search (string pinbr, string cinbr)
public function integer wf_update_hist ()
end prototypes

public subroutine wf_treeview (string sitem);/* Treeview내역을 생성 */
Datastore ds_bom
Treeviewitem tvi
String sToday
Long 		l_row, L_gbn, H_item, L_parent, L_gbn_b, E_item
Long 		L_level[20]
Integer	I_cnt
String 	L_userid
Boolean  B_child 
string sitdsc, sjijil, sispec
 
/* 전체내역을 삭제 */
long tvi_hdl = 0

DO UNTIL tv_1.FindItem(RootTreeItem!, 0) = -1	
	      tv_1.DeleteItem(tvi_hdl)
LOOP
 
/* Bom내역을 Retrieve */
ds_bom = Create datastore
ds_bom.dataobject = "d_pdm_01530_2"
ds_bom.settransobject(sqlca)
If ds_bom.retrieve(sItem) < 1 Then Return

/* 상위품번을 Setting */
tvi.label = sItem
tvi.data  = sItem
tvi.children = True
tvi.level  = 0
tvi.pictureindex = 1
tvi.selectedpictureindex = 1
H_item = tv_1.insertitemlast(0, tvi)
 
For L_row=1 to ds_bom.rowcount()
	 L_gbn    = Dec(ds_bom.object.lvlno[L_row])
	 
	 B_child  = False
	 
	 If L_row < ds_bom.rowcount() Then
		 If L_gbn < Dec(ds_bom.object.lvlno[L_row + 1]) Then
		    B_child = True	
		 End if
	 End if

	 /* Root Level */
	 If 	  L_gbn = 0 Then
		 	  L_parent = 0
			  I_cnt    = 0
	 ElseIf L_gbn > L_gbn_b Then
			  I_cnt++		
			  L_level[I_cnt] = H_item
			  L_parent		  = H_item
    Elseif L_gbn < L_gbn_b Then
			  I_cnt = L_gbn
			  L_parent		  = L_level[i_cnt]
  	 Else
			  L_parent		  = L_level[i_cnt]
	 End if

	 If isnull(ds_bom.object.ispec[L_row]) Then
		 ds_bom.object.ispec[L_row] = ' '
	 End if

    sitdsc  = ds_bom.object.itdsc[L_row]
    sispec  = ds_bom.object.ispec[L_row]
    sjijil  = ds_bom.object.jijil[L_row]

	 if isnull(sitdsc) then sitdsc = ""
	 if isnull(sispec) then sispec = ""
	 if isnull(sjijil) then sjijil = ""

    L_gbn_b   = L_gbn
	 
	 if IsNull(ds_bom.object.pcb_name[L_row]) or  Trim(ds_bom.object.pcb_name[L_row])  = '' Then
		 tvi.label = '[' + ds_bom.object.usseq[L_row] + '] ' + ds_bom.object.cinbr[L_row] + &
		             ' / ' + sitdsc + ' / ' + sispec
	 else
		 tvi.label = '[' + ds_bom.object.usseq[L_row] + '] ' + ds_bom.object.cinbr[L_row] + &
		             ' / ' + sitdsc + ' / ' + sispec + ' (' + ds_bom.object.pcb_name[L_row] + ')'
	 end if
	 
	 tvi.data  = ds_bom.object.cinbr[L_row] 
	  
	 tvi.children = b_child
	 If b_child  Then
		 tvi.pictureindex = 1
		 tvi.Selectedpictureindex = 2
	 Else
		 tvi.pictureindex = 0
		 tvi.Selectedpictureindex = 0
	 End if
	 tvi.level  = L_gbn
	 H_item = tv_1.insertitemsort(L_parent, tvi)			// Root의 내용을 Sort를 하면서 하고자 하는 경우
	 If is_masterno = ds_bom.Object.cinbr[L_row] Then
		 E_item = H_item
	 End If
/*	 H_item = tv_1.insertitemlast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 */
Next

//H_item = tv_1.FindItem(RootTreeItem!, 0) 
//			tv_1.Expanditem(H_item)

tv_1.SelectItem(E_item)
tv_1.ExpandItem(E_item)

Destroy ds_bom

return  

end subroutine

public subroutine wf_treeview_delete ();treeviewitem tvi_curr, tvi_prve
Long 		currenthandle, Parenthandle
String 	sPinbr, sCinbr, susseq

currenthandle = tv_1.finditem(currenttreeitem!, currenthandle)
If tv_1.getitem(currenthandle, tvi_curr)		  = -1 Then Return

Parenthandle = tv_1.finditem(parenttreeitem!, currenthandle)
If tv_1.getitem(parenthandle, tvi_Prve) = -1 Then Return

sPinbr = tvi_prve.DATA
sCinbr = tvi_curr.DATA
susseq = mid(tvi_curr.label, 2, 5)

if MessageBox("삭제확인", "삭제하시겠읍니까", question!, yesno!) = 1 then
	delete from pstruc
	where pinbr = :spinbr and cinbr = :sCinbr and usseq = :susseq;
	
	Commit;
	
	/* 현재 tree삭제 */
	tv_1.deleteitem(currenthandle)
End if

end subroutine

public function integer wf_treeview_seek (treeview ltvi, long ahandle, string old_pinbr, string old_usseq, string new_pinbr, string new_cinbr, string arg_cinbr);
 
 SELECT "PSTRUC"."PINBR",   
         "PSTRUC"."CINBR",   
         "PSTRUC"."USSEQ",   
         "PSTRUC"."QTYPR",   
         "PSTRUC"."ADTIN",   
         "PSTRUC"."OPSNO",   
         "PSTRUC"."EFRDT",   
         "PSTRUC"."EFTDT",   
         "PSTRUC"."GUBUN",   
         "PSTRUC"."DCINBR",   
         "PSTRUC"."BOMEND",   
         "PSTRUC"."PCBLOC",   
         "PSTRUC"."RMKS",   
         "PSTRUC"."GUBUN2"  
    INTO :pstruc_str.sPinbr,   
         :pstruc_str.sCinbr,   
         :pstruc_str.sUsseq,   
         :pstruc_str.dQtypr,   
         :pstruc_str.dAdtin,   
         :pstruc_str.sOpsno,   
         :pstruc_str.sEfrdt,   
         :pstruc_str.sEftdt,   
         :pstruc_str.sGubun,   
         :pstruc_str.sDcinbr,   
         :pstruc_str.sBomend,   
         :pstruc_str.sPcbloc,   
         :pstruc_str.sRmks,   
         :pstruc_str.gubun2  
    FROM "PSTRUC"  
   WHERE ( "PSTRUC"."PINBR" = :old_pinbr ) AND  
         ( "PSTRUC"."CINBR" = :arg_cinbr ) AND  
         ( "PSTRUC"."USSEQ" = :old_usseq )   ;
//MESSAGEBOX(OLD_PINBR, OLD_USSEQ)			
  If sqlca.sqlcode <> 0 Then
	 MESSAGEBOX(arg_cinbr,SQLCA.SQLERRTEXT)
	  rollback;
	  Messagebox("BOM Select", "이전 자료 복사중 오류가 발생", stopsign!)
	  return -1
  End if
			
 Delete From PSTRUC where pinbr = :Old_pinbr and cinbr = :arg_cinbr and usseq = :old_usseq;
 
  If sqlca.sqlcode <> 0 Then
	  rollback;
	  Messagebox("BOM Deletel", "이전 자료 삭제중 오류가 발생", stopsign!)
	  return -1
  End if 			


treeviewitem ftvi, ftvi1
Long Lhandle, Llevel, H_item, Lcount
String sTitem, sSitem
Integer Li_check = 0

timer(.25)
iBflash = true

IF tv_1.getitem(il_droptarget, ftvi1) = -1 then
	return 0
end if

sTitem = ftvi1.data
H_item =	tv_1.FindItem(currentTreeItem!, 0) 
			tv_1.Expandall(H_item)						

If Ltvi.getitem(ahandle, ftvi) = -1 then
	Return 0
End if

If ftvi1.data = ftvi.data Then
	Messagebox("상하위 구성", "상하위 구성내역이 동일합니다" + '~n' + &
								  ftvi.label, stopsign!)
	Return -1
End if

iIcnt = 0
sSitem = ftvi.data
Llevel = ftvi.level

/* 상위 Loop검색 */
Lcount = 0;
select count(*)
  into :Lcount
  from (select level, pinbr, cinbr
		  from PSTRUC
		 connect by  prior pinbr = cinbr
		 start with cinbr = :sTitem) a
 where a.pinbr = :sSitem;
 
If Lcount > 0 then
	Messagebox("상위Loop", "변경하려고 하는 품목이 상위에 구성되어 있읍니다" + '~n' + &
								  ftvi.label, stopsign!)
	Return -1
End if

/* 시작 지점 */
lhandle = ltvi.finditem(childtreeitem!, ahandle)
Li_check = 0

do While True
		ltvi.getitem(lhandle, ftvi)		
		If ftvi.level <= Llevel then
			Exit
		End if
		

		Li_check++
		sSitem = ftvi.data
		
		If sSitem = sTitem Then
			Messagebox("상위Loop", "변경하려고 하는 품목이 상위에 구성되어 있읍니다" + '~n' + &
										  ftvi.label, stopsign!)
			Return -1
		End if		
		
		
		/* 상위 Loop검색 */
		Lcount = 0;
		select count(*)
		  into :Lcount
		  from (select level, pinbr, cinbr
				  from PSTRUC
				 connect by  prior pinbr = cinbr
				 start with cinbr = :sTitem) a
		 where a.pinbr = :sSitem;
		 
		If Lcount > 0 then
			Messagebox("상위Loop", "변경하려고 하는 품목이 상위에 구성되어 있읍니다" + '~n' + &
										  ftvi.label, stopsign!)
			Return -1
	   End if
		
		/* 하위 Loop검색 */
//		Lcount = 0;
//		select count(*)
//		  into :Lcount
//		  from (select level, pinbr, cinbr
//				  from PSTRUC
//				 connect by  prior cinbr = pinbr
//				 start with pinbr = :sTitem) a
//		 where a.cinbr = :sSitem;
//		 
//		If Lcount > 0 then
//			Messagebox("하위Loop", "변경하려고 하는 품목이 하위에 구성되어 있읍니다" + '~n' + &
//										  ftvi.label, stopsign!)
//			st_1.text = ""
//			iBflash = false
//			timer(0)	
//			setpointer(arrow!)
//
//			Return -1
//	   End if
		
		iIcnt++
		iSlabel[iIcnt] = ftvi.label
		iSdata[iIcnt]  = ftvi.data
		iIpic[iIcnt]   = ftvi.pictureindex
		iIsel[iIcnt]   = ftvi.selectedpictureindex
		iBchild[iIcnt] = ftvi.children
		iIlevel[iIcnt] = ftvi.level
		
		/* 하위 Level 검색 */
		Lhandle = ltvi.finditem(Nextvisibletreeitem!, lhandle)
		If Lhandle = -1 or ftvi.level <= Llevel then
			Exit
		End if	
Loop 

If Li_check = 0 then
		/* 상위 Loop검색 */
		Lcount = 0;
		select count(*)
		  into :Lcount
		  from (select level, pinbr, cinbr
				  from PSTRUC
				 connect by  prior pinbr = cinbr
				 start with cinbr = :sTitem) a
		 where a.pinbr = :sSitem;
		 
		If Lcount > 0 then
			Messagebox("상위Loop", "변경하려고 하는 품목이 상위에 구성되어 있읍니다" + '~n' + &
										  ftvi.label, stopsign!)
			Return -1
	   End if
		
		/* 하위 Loop검색 */
//		Lcount = 0;
//		select count(*)
//		  into :Lcount
//		  from (select level, pinbr, cinbr
//				  from PSTRUC
//				 connect by  prior cinbr = pinbr
//				 start with pinbr = :sTitem) a
//		 where a.cinbr = :sSitem;
//		 
//		If Lcount > 0 then
//			Messagebox("하위Loop", "변경하려고 하는 품목이 하위에 구성되어 있읍니다" + '~n' + &
//										  ftvi.label, stopsign!)
//			st_1.text = ""
//			iBflash = false
//			timer(0)	
//			setpointer(arrow!)
//
//			Return -1
//	   End if
End if
return 0
end function

public function integer wf_update (string old_pinbr, string old_usseq, string new_pinbr, ref string new_usseq, string arg_cinbr);String sPinbr, sCinbr, sUsseq, sOpsno, sEfrdt, sEftdt, sGubun, sDcinbr, sBomend, sPcbloc, sRmks
Decimal {4} dQtypr, dAdtin

/* 순번은 상위품번을 기준으로 Max-No를 지정한다 */
Select substr(to_char(to_number(max(usseq)) + 10, '00000'), 2, 5)
  Into :susseq
  From pstruc
 Where pinbr = :new_pinbr;

if isnull(susseq) or trim(susseq) ='' then susseq = '00010'

 
 INSERT INTO "PSTRUC"  
         ( "PINBR",   
           "CINBR",   
           "USSEQ",   
           "QTYPR",   
           "ADTIN",   
           "OPSNO",   
           "EFRDT",   
           "EFTDT",   
           "GUBUN",   
           "DCINBR",   
           "BOMEND",   
           "PCBLOC",   
           "RMKS",
			  "GUBUN2" )  
  VALUES ( :new_pinbr,   
           :pstruc_str.scinbr,   
           :susseq,   
           :pstruc_str.dQtypr,   
           :pstruc_str.dAdtin,   
           :pstruc_str.sOpsno,   
           :pstruc_str.sEfrdt,   
           :pstruc_str.sEftdt,   
           :pstruc_str.sGubun,   
           :pstruc_str.sDcinbr,   
           :pstruc_str.sBomend,   
           :pstruc_str.sPcbloc,   
           :pstruc_str.sRmks,   
           :pstruc_str.gubun2 )  ;

  If sqlca.sqlcode <> 0 Then
	  Messagebox("BOM Insert", "신규 자료 입력중 오류가 발생", stopsign!)
	  return -1
  End if
  
  commit;
  
  new_usseq = susseq

Return 0  

//String sPinbr, sCinbr, sUsseq, sOpsno, sEfrdt, sEftdt, sGubun, sDcinbr, sBomend, sPcbloc, sRmks
//Decimal {4} dQtypr, dAdtin
//
///* 순번은 상위품번을 기준으로 Max-No를 지정한다 */
//Select substr(to_char(to_number(max(usseq)) + 10, '00000'), 2, 5)
//  Into :susseq
//  From pstruc
// Where pinbr = :new_pinbr;
//
//if isnull(susseq) or trim(susseq) ='' then susseq = '00010'
//
// 
// INSERT INTO "PSTRUC"  
//         ( "PINBR",   
//           "CINBR",   
//           "USSEQ",   
//           "QTYPR",   
//           "ADTIN",   
//           "OPSNO",   
//           "EFRDT",   
//           "EFTDT",   
//           "GUBUN",   
//           "DCINBR",   
//           "BOMEND",   
//           "PCBLOC",   
//           "RMKS",
//			  "GUBUN2" )  
//  VALUES ( :new_pinbr,   
//           :pstruc_str.scinbr,   
//           :susseq,   
//           :pstruc_str.dQtypr,   
//           :pstruc_str.dAdtin,   
//           :pstruc_str.sOpsno,   
//           :pstruc_str.sEfrdt,   
//           :pstruc_str.sEftdt,   
//           :pstruc_str.sGubun,   
//           :pstruc_str.sDcinbr,   
//           :pstruc_str.sBomend,   
//           :pstruc_str.sPcbloc,   
//           :pstruc_str.sRmks,   
//           :pstruc_str.gubun2 )  ;
//
//  If sqlca.sqlcode <> 0 Then
//	  Messagebox("BOM Insert", "신규 자료 입력중 오류가 발생", stopsign!)
//	  return -1
//  End if
//  
//  commit;
//  
//  new_usseq = susseq
//
//Return 0  
end function

public function integer wf_estupdate ();string spinbr, scinbr
integer ii
Long Lrow

spinbr = is_masterno

For Lrow = 1 to dw_insert.rowcount()
	 If Len(dw_insert.getitemstring(Lrow, "pstruc_usseq")) <> 5 then
		 MessageBox("사용번호", "사용번호는 5자리입니다(ex:00030)", stopsign!)
		 dw_insert.setcolumn("pstruc_usseq")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if
	 
	 scinbr = dw_insert.getitemstring(Lrow, "pstruc_cinbr")
	 If isnull(dw_insert.getitemstring(Lrow, "pstruc_cinbr")) or &
	    Trim(dw_insert.getitemstring(Lrow, "pstruc_cinbr"))  = '' then
		 MessageBox("품목번호", "품목번호는 필수입니다.", stopsign!)
		 dw_insert.setcolumn("pstruc_cinbr")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if	
	 
	 IF SPINBR = SCINBR THEN
		 MessageBox("품목번호", "상하위 품목이 동일합니다.", stopsign!)
		 dw_insert.setcolumn("pstruc_cinbr")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1				
	 END IF
	 
	 If dw_insert.getitemdecimal(Lrow, "pstruc_qtypr")  = 0 then
		 MessageBox("구성수량", "구성수량은 필수입니다.", stopsign!)
		 dw_insert.setcolumn("pstruc_qtypr")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if	
	 
	 If f_datechk(dw_insert.getitemstring(Lrow, "pstruc_efrdt")) = -1  then
		 MessageBox("적용시작일", "일자가 부정확합니다..", stopsign!)
		 dw_insert.setcolumn("pstruc_efrdt")
		 dw_insert.setrow(Lrow)
		 dw_insert.scrolltorow(Lrow)
		 dw_insert.setfocus()
		 return -1		
	 End if		 
	 
	 If f_datechk(dw_insert.getitemstring(Lrow, "pstruc_eftdt")) = -1  then
		 IF dw_insert.getitemstring(Lrow, "pstruc_eftdt") <> '99999999' THEN		 
			 MessageBox("적용완료일", "일자가 부정확합니다..", stopsign!)
			 dw_insert.setcolumn("pstruc_eftdt")
			 dw_insert.setrow(Lrow)
			 dw_insert.scrolltorow(Lrow)
			 dw_insert.setfocus()
			 return -1
		 End if
	 End if	
	 
	 if isnull(dw_insert.getitemstring(Lrow, "pstruc_opsno")) or &
	    Trim(dw_insert.getitemstring(Lrow, "pstruc_opsno")) = '' then
	 	 dw_insert.setitem(Lrow, "pstruc_opsno", '9999')
 
	 End if
	 
	 ii = wf_search(spinbr, scinbr)
	 if ii <> 1 then
		 return -1
	End if
NExt

return 1
end function

public subroutine wf_treeview_make (treeview ltvi, long ahandle);
treeviewitem tvi, tvi_prv
Long Lhandle, Llevel, Licnt, L_gbn_b, L_level[], L_parent, L_gbn, H_item
Integer I_cnt

I_cnt 	= 0
L_gbn_b	= 0
H_item   = aHandle

For Licnt=1 to iIcnt
	 L_gbn    = iIlevel[Licnt]
	 
	 /* Root Level */
	 If 	  L_gbn = 0 Then
		 	  L_parent = 0
			  I_cnt    = 0
	 ElseIf L_gbn > L_gbn_b Then
			  I_cnt++		
			  L_level[I_cnt] = H_item
			  L_parent		  = H_item
    Elseif L_gbn < L_gbn_b Then
			  I_cnt = I_cnt - 1
			  L_parent		  = L_level[i_cnt]
  	 Else
			  L_parent		  = L_level[i_cnt]
	 End if
	 
    L_gbn_b   = L_gbn
	 tvi.label 	 					= iSlabel[Licnt]
	 tvi.data 	 					= iSdata[Licnt]
	 tvi.children 					= iBchild[Licnt]
	 tvi.pictureindex 			= iIpic[Licnt]
	 tvi.Selectedpictureindex 	= iIsel[Licnt]
	 H_item = ltvi.insertitemsort(L_parent, tvi)			// Root의 내용을 Sort를 하면서 하고자 하는 경우
/*	 H_item = tv_1.insertitemlast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 */
	 
Next

return
end subroutine

public function integer wf_refresh ();tv_1.setredraw(false)
wf_treeview(dw_head.getitemstring(1, "itnbr"))
tv_1.setredraw(true)

dw_insert.reset()

return 1
end function

public function integer wf_search (string pinbr, string cinbr);
// 1) 역전개 다단계 검색
//    상위품번을 기준으로 구성하려는 하위품번이 상위에 존재하는가에 대한 검색(다단계)
// 2) 상위, 하위가 가상품번인지를 검색한다.(두개다 가상인 경우 return)

integer Li_count
String  sitem, sname, snull, sopseq

Setnull(snull)

Sle_msg.text = "User Loop를 검색중입니다"

Li_count = 0
select count(*)
  Into :Li_count
  from (select level, pinbr, cinbr
		  from pstruc
		 connect by  prior pinbr = cinbr
		 start with cinbr = :pinbr) a
 where a.pinbr = :cinbr;	


if  Li_count > 0 	then      // 하위품번이 상위에 구성되어 있으면
    messagebox("하위품번", "구성하려고 하는 하위품번이 상위에 구성되어 있습니다", stopsign!)
    dw_insert.setfocus()
	 Sle_msg.text = ''
    return -1
end if

//Sle_msg.text = "상위/하위 품목에 유효성을 체크중........"
//
//Li_count = 0
//
//SELECT COUNT(*) 
//  INTO :Li_count 
//  FROM ITEMAS 
// WHERE ITNBR IN (:pinbr, :cinbr) AND ITTYP = '8' ;
//
//if  Li_count > 1 	then      // 상/하위가 가상품목인 경우 바로 return
//    messagebox("하위품번", "상위 / 하위 품목이 가상품번입니다. 품목을 확인하세요!", stopsign!)
//    dw_insert.setfocus()
//	 Sle_msg.text = ''
//    return -1
//end if

Sle_msg.text = ''

return 1


end function

public function integer wf_update_hist ();string s_frday, s_frtime

s_frday = f_today()
	
s_frtime = f_totime()

UPDATE "PGM_HISTORY"  
      SET "UPD_DATE" = :s_frday,   
             "UPD_TIME" = :s_frtime
 WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

IF SQLCA.SQLCODE = 0 THEN 
   RETURN 1
ELSE 	  
   RETURN -1
END IF	  

end function

on w_pdm_01530.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.tv_1=create tv_1
this.st_splitbar=create st_splitbar
this.cbx_1=create cbx_1
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_5=create p_5
this.p_6=create p_6
this.cb_ys=create cb_ys
this.p_7=create p_7
this.cbx_2=create cbx_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.tv_1
this.Control[iCurrent+3]=this.st_splitbar
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.p_3
this.Control[iCurrent+8]=this.p_4
this.Control[iCurrent+9]=this.p_5
this.Control[iCurrent+10]=this.p_6
this.Control[iCurrent+11]=this.cb_ys
this.Control[iCurrent+12]=this.p_7
this.Control[iCurrent+13]=this.cbx_2
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_1
end on

on w_pdm_01530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.tv_1)
destroy(this.st_splitbar)
destroy(this.cbx_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_5)
destroy(this.p_6)
destroy(this.cb_ys)
destroy(this.p_7)
destroy(this.cbx_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;st_splitbar.of_Register(tv_1, st_splitbar.LEFT)
st_splitbar.of_Register(dw_insert, st_splitbar.RIGHT)
cbx_1.text = '상세'
dw_insert.Modify("DataWindow.Header.Height=68")		
dw_insert.Modify("DataWindow.Detail.Height=72")		
   
postevent("ue_open")







end event

event dragwithin;call super::dragwithin;tv_1.triggerevent('ue_downscroll')
end event

event ue_open;call super::ue_open;dw_head.settransobject(sqlca)
dw_insert.settransobject(sqlca)

p_can.triggerevent(clicked!)

dw_head.setcolumn("itnbr")
dw_head.setfocus()


IF gs_gubun = 'ATTENTION' AND gs_code > '.' THEN 

	if dw_head.rowcount() <> 1 then return
	dw_head.object.itnbr[1] = gs_code
	dw_head.triggerevent(itemchanged!)
end if
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01530
integer x = 1595
integer y = 288
integer width = 3013
integer height = 1996
string dataobject = "d_pdm_01530_4"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::retrieveend;call super::retrieveend;if rowcount > 0 then
	cbx_1.enabled = true
	cbx_2.enabled = true
	
	cbx_2.checked = false
	
	p_mod.enabled    = true
	p_addrow.enabled = true
	p_delrow.enabled = true

	p_mod.picturename    = "C:\erpman\image\저장_up.gif"
	p_addrow.picturename = "C:\erpman\image\행추가_up.gif"
	p_delrow.picturename = "C:\erpman\image\행삭제_up.gif"
	
Else
	cbx_1.enabled = false
	cbx_2.enabled = false
	
	cbx_2.checked = false
End if
end event

event dw_insert::retrievestart;call super::retrievestart;cbx_1.text = '상세'
cbx_1.checked = false
dw_insert.Modify("DataWindow.Header.Height=68")		
dw_insert.Modify("DataWindow.Detail.Height=72")		
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "pstruc_cinbr"

		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"pstruc_cinbr",gs_code)
		PostEvent(ItemChanged!)
	 Case "pstruc_opsno"
			OpenWithParm(w_routng_popup,is_masterno)
			IF IsNull(Gs_Code) THEN RETURN
			this.SetItem(nrow,"pstruc_opsno",Gs_Code)
			this.setcolumn("pstruc_opsno")
			triggerevent(itemchanged!)
END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode,snull,sopsno
Long    nRow, Lprv

SetNull(sNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case	"pstruc_cinbr" 
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
			SetItem(nRow,"pstruc_cinbr",   snull)			
			SetItem(nRow,"itemas_itemas_itdsc",   snull)
			SetItem(nRow,"itemas_itemas_ispec",   snull)
			SetItem(nRow,"itemas_itemas_jijil",   snull)
			Return 1
		END IF
	
		SetItem(nRow,"itemas_itemas_itdsc",   sItDsc)
		SetItem(nRow,"itemas_itemas_ispec",   sIspec)
		SetItem(nRow,"itemas_itemas_jijil",   sJijil)

		If sitnbr = this.getItemString(nrow, "pstruc_pinbr") Then
			MessageBox("품번", "상위품번은 BOM에 등록될수 없습니다.", stopsign!)
			SetItem(nRow,"pstruc_cinbr",   snull)			
			SetItem(nRow,"itemas_itemas_itdsc",   snull)
			SetItem(nRow,"itemas_itemas_ispec",   snull)
			SetItem(nRow,"itemas_itemas_jijil",   snull)
			return 1
		End If

	/* 규격 */
	Case "itemas_itemas_itdsc"
		sItdsc = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"pstruc_cinbr",sItnbr)
			SetColumn("pstruc_cinbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,"itemas_itemas_itdsc",   snull)
			SetItem(nRow,"itemas_itemas_ispec",   snull)
			SetItem(nRow,"itemas_itemas_jijil",   snull)
			SetColumn("itemas_itemas_itdsc")
			Return 1
		End If		
	Case	"pstruc_opsno" 
		sopsno = gettext()
		SELECT opdsc
		  INTO :sItDsc
		  FROM routng
		 WHERE itnbr = :is_masterno And opseq = :sopsno;

		IF SQLCA.SQLCODE <> 0 THEN

			MessageBox("공정", "품목에 정의되지 않은 공정입니다.", stopsign!)
			SetItem(nRow,"pstruc_opsno",  '9999')
			SetItem(nRow,"routng_opdsc",   snull)
			Return 1
		END IF
	
			SetItem(nRow,"routng_opdsc",   sitdsc)		
	Case	"pstruc_efrdt" 
		sopsno = gettext()		
		if f_datechk(sopsno) = -1 then
			MessageBox("확인", "시작일자가 부정확합니다", stopsign!)
			setitem(nrow, "pstruc_efrdt", f_today())
			return 1
		End if
	Case	"pstruc_eftdt" 
		sopsno = gettext()
		if f_datechk(sopsno) = -1 then
			MessageBox("확인", "시작일자가 부정확합니다", stopsign!)
			setitem(nrow, "pstruc_eftdt", '99991231')
			return 1
		End if
	Case	"pstruc_gubun" 
		sopsno = gettext()
		
		If Nrow = 1 And sopsno = '2' then
			MessageBox("대체", "첫번째 행은 대체품목으로 지정될 수 없읍니다", stopsign!)
			setitem(nrow, "pstruc_gubun", '1')
			return 1
		End if

		if sopsno = '2' then
			For Lprv = nrow - 1 to 1 step -1
				if getitemstring(Lprv, "pstruc_gubun") = '1' then
					setitem(nrow, "pstruc_usseq", getitemstring(Lprv, "pstruc_usseq"))
					setitem(nrow, "pstruc_dcinbr", getitemstring(Lprv, "pstruc_cinbr"))
					Exit
				End if
			Next
		Else	
			setitem(nrow, "pstruc_dcinbr", snull)
		End if		
END Choose

end event

type p_delrow from w_inherite`p_delrow within w_pdm_01530
integer x = 3909
integer y = 52
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long Lrow 
String sitnbr, susseq, sSitem


Lrow = dw_insert.getrow()
if Lrow < 1 then return

sitnbr = dw_insert.getitemstring(Lrow, "pstruc_cinbr")
susseq = dw_insert.getitemstring(Lrow, "pstruc_usseq")
if isnull(sitnbr) then sitnbr = '.'

if MessageBox("삭제확인", "품번 : " + sitnbr + '~n' + &
								  "을 삭제하시겠읍니까?", question!, yesno!) = 1 then
								  
	ib_any_typing = true								  							  
	dw_insert.deleterow(Lrow)
	
	if sitnbr <> '.' then
		Do while true
			If Lrow > dw_insert.rowcount() Then Exit			
			If sitnbr = dw_insert.getitemstring(Lrow, "pstruc_dcinbr") And &
				susseq = dw_insert.getitemstring(Lrow, "pstruc_usseq")  then
				dw_insert.deleterow(Lrow)
				Continue
			End if
			Lrow++
		Loop
	End if
								  
End if
end event

type p_addrow from w_inherite`p_addrow within w_pdm_01530
integer x = 3735
integer y = 52
boolean enabled = false
end type

event p_addrow::clicked;call super::clicked;long lRow, lIn, ll_usseq, i, ll_count, ll_maxseq 
String ls_pinbr, ls_seq, ls_maxseq

dw_insert.setredraw( false)

Lin  = dw_insert.getrow()
ll_count = dw_insert.rowCount()
//lrow = dw_insert.insertrow(Lin+1)
lrow = dw_insert.insertrow(0)


select distinct a.pinbr
into  :ls_pinbr
from pstruc a,
	  itemas b
where a.pinbr = :is_masterno
and   a.cinbr = b.itnbr ;

If sqlca.sqlcode <> 0 and ll_count = 0  Then
	dw_insert.setitem(1, "pstruc_usseq","00010" )	
Elseif sqlca.sqlcode <> 0 and ll_count > 0 Then

	ls_maxseq = dw_insert.getItemString(1,"pstruc_usseq")
	
	For i = 2 to ll_count + 1
		ls_seq = dw_insert.getItemString(i,"pstruc_usseq")
		If long(ls_maxseq) < long(ls_seq) Then
			ls_maxseq = ls_seq
		End If

	Next
	
	ll_maxseq = long(ls_maxseq) + 10
	
	select to_char(:ll_maxseq,'FM00009') into :ls_maxseq from dual;
	
	
	dw_insert.setitem(lRow, "pstruc_usseq", ls_maxseq)
else
	
	ls_maxseq = dw_insert.getItemString(1,"pstruc_usseq")
	
	For i = 2 to ll_count + 1
		ls_seq = dw_insert.getItemString(i,"pstruc_usseq")
		If long(ls_maxseq) < long(ls_seq) Then
			ls_maxseq = ls_seq
		End If

	Next
	
	ll_maxseq = long(ls_maxseq) + 10
	
	select to_char(:ll_maxseq,'FM00009') into :ls_maxseq from dual;
	
	
	dw_insert.setitem(lRow, "pstruc_usseq", ls_maxseq)	
	
End If

dw_insert.setitem(lRow, "pstruc_pinbr", is_masterno)
dw_insert.setitem(lRow, "pstruc_efrdt", f_today())
dw_insert.setrow(lrow)
dw_insert.setcolumn("pstruc_usseq")
dw_insert.setfocus()

dw_insert.setredraw( true)
end event

event p_addrow::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event p_addrow::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from w_inherite`p_search within w_pdm_01530
boolean visible = false
integer x = 3369
integer y = 2428
end type

type p_ins from w_inherite`p_ins within w_pdm_01530
boolean visible = false
integer x = 3991
integer y = 2432
end type

type p_exit from w_inherite`p_exit within w_pdm_01530
integer x = 4430
integer y = 52
end type

type p_can from w_inherite`p_can within w_pdm_01530
integer x = 4256
integer y = 52
end type

event p_can::clicked;call super::clicked;dw_insert.reset()

p_mod.enabled = false
p_addrow.enabled = false
p_delrow.enabled = false

p_mod.picturename = "C:\erpman\image\저장_d.gif"
p_addrow.picturename = "C:\erpman\image\행추가_d.gif"
p_delrow.picturename = "C:\erpman\image\행삭제_d.gif"

cbx_1.text = '상세'
cbx_1.checked = false
cbx_1.triggerevent(clicked!)
cbx_1.enabled = false

tv_1.setredraw(false)
wf_treeview('')
tv_1.setredraw(true)

dw_head.setredraw(false)
dw_head.reset()
dw_head.insertrow(0)
dw_head.setredraw(true)

dw_head.setfocus()
end event

type p_print from w_inherite`p_print within w_pdm_01530
boolean visible = false
integer x = 3584
integer y = 2428
end type

type p_inq from w_inherite`p_inq within w_pdm_01530
boolean visible = false
integer x = 3781
integer y = 2428
end type

type p_del from w_inherite`p_del within w_pdm_01530
integer x = 2926
integer y = 52
end type

event p_del::clicked;call super::clicked;Long Lrow, i, ll_cnt, ll_find
String sitnbr, susseq, sSitem, ls_chk

ll_cnt = dw_insert.rowcount()

ll_find = dw_insert.find("chk = 'Y'",1,ll_cnt)
if ll_find < 1 then 
	messagebox("확인",'선택된 자품번이 존재하지 않습니다')
	return
end if


if MessageBox("삭제확인", "선택된 자품번을 삭제하시겠읍니까?", question!, yesno!,2) = 2 then
	return
end if

FOR i = ll_cnt to 1 step -1
	
	ls_chk = dw_insert.object.chk[i]
	if ls_chk = 'N' or isnull(ls_chk) then continue
	
	Lrow = i
	if Lrow < 1 then return
	
	sitnbr = dw_insert.getitemstring(Lrow, "pstruc_cinbr")
	susseq = dw_insert.getitemstring(Lrow, "pstruc_usseq")
	if isnull(sitnbr) then sitnbr = '.'
	ib_any_typing = true								  							  
	dw_insert.deleterow(Lrow)
	if sitnbr <> '.' then
		Do while true
			If Lrow > dw_insert.rowcount() Then Exit			
			If sitnbr = dw_insert.getitemstring(Lrow, "pstruc_dcinbr") And &
				susseq = dw_insert.getitemstring(Lrow, "pstruc_usseq")  then
				dw_insert.deleterow(Lrow)
				Continue
			End if
			Lrow++
		Loop
	End if
next	
end event

type p_mod from w_inherite`p_mod within w_pdm_01530
integer x = 4082
integer y = 52
boolean enabled = false
end type

event p_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return

if messagebox("저장확인", "저장하시겠읍니까?", question!, yesno!) = 2 then return

long i

for i = 1 to dw_insert.rowcount()
	if dw_insert.GetItemStatus(i, 0, Primary!) = New! or dw_insert.GetItemStatus(i, 0, Primary!) = NewModified! then
		dw_insert.SetItem(i, "pstruc_crt_user", gs_userid)
	elseif dw_insert.GetItemStatus(i, 0, Primary!) = DataModified! then
		dw_insert.SetItem(i, "pstruc_upd_user", gs_userid)
	end if
next

if wf_estupdate() = -1 then
 	return
end if

if dw_insert.update() = -1 then
	rollback;
	Messagebox("저장실패", "저장중 오류발생", stopsign!)
	return
end if

/* 저장 로그 확인 */
IF wf_update_hist() <= 0 THEN
	ROLLBACK;
	RETURN
END IF

commit;

ib_any_typing = false

dw_insert.reset()

dw_insert.Retrieve(is_masterno)

wf_refresh()
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01530
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01530
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01530
end type

type cb_del from w_inherite`cb_del within w_pdm_01530
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01530
end type

type cb_print from w_inherite`cb_print within w_pdm_01530
end type

type st_1 from w_inherite`st_1 within w_pdm_01530
integer x = 1422
integer y = 2484
integer width = 1582
string text = ""
end type

type cb_can from w_inherite`cb_can within w_pdm_01530
integer x = 2117
integer y = 2784
end type

type cb_search from w_inherite`cb_search within w_pdm_01530
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01530
integer x = 910
integer y = 3244
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01530
end type

type dw_head from u_key_enter within w_pdm_01530
event ue_key pbm_dwnkey
integer x = 18
integer y = 24
integer width = 2528
integer height = 244
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdm_01530_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;call super::dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)

RETURN 1
end event

event rbuttondown;call super::rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

sle_msg.text = ''
nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)	 
	Case "itdsc"
		gs_gubun = '1'
		gs_codename = GetText()
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "ispec", "jijil"
		gs_gubun = '1'
		open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetColumn("itnbr")
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
END Choose
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode, x_itnbr, ls_x
Decimal dnull
Long    nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(dNull)

nRow   = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case	"itnbr" 
		sitnbr = gettext()
//		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
//		  INTO :sItDsc,   		 :sIspec, 		:sJijil
//		  FROM "ITEMAS" , "ITNCT"
//		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' 
//		     AND  "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" 
//		     AND  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" 
//		     AND  "ITNCT"."PORGU" LIKE :gs_saupj ;

		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS" , "ITNCT"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' 
		     AND  "ITEMAS"."ITTYP" = "ITNCT"."ITTYP"(+) 
		     AND  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS"(+) ;


		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
         p_can.triggerevent(clicked!)
			Return 1
		END IF
	
		SetItem(nRow,"itdsc",   sItDsc)
		SetItem(nRow,"ispec",   sIspec)
		SetItem(nRow,"jijil",   sJijil)
		
	/* 규격 */
	Case "itdsc"
		sItdsc = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
         p_can.triggerevent(clicked!)			
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         p_can.triggerevent(clicked!)
			SetColumn("itemas_itdsc")
			Return 1
		End If
		
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         		p_can.triggerevent(clicked!)
			SetColumn("ispec")
			Return 1
		End If		
		
	/* 재질 */
	Case "jijil"
		sjijil = trim(GetText())	
		/* 품명으로 품번찾기 */
		f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
         p_can.triggerevent(clicked!)
			SetColumn("itemas_jijil")
			Return 1
		End If	
END Choose

dw_insert.reset()

cbx_1.text = '상세'
cbx_1.checked = false
cbx_1.triggerevent(clicked!)
cbx_1.enabled = false

is_masterno = sitnbr
wf_treeview(sitnbr)

Long Lrow
Lrow = 0  
Select count(*) into :Lrow from Pstruc where pinbr = :sItnbr;
If Lrow < 1 then
	p_mod.enabled    = true
	p_addrow.enabled = true
	p_delrow.enabled = true
	p_mod.picturename    = "C:\erpman\image\저장_up.gif"
	p_addrow.picturename = "C:\erpman\image\행추가_up.gif"
	p_delrow.picturename = "C:\erpman\image\행삭제_up.gif"	
End if
end event

event dragwithin;call super::dragwithin;tv_1.triggerevent('ue_upscroll')
end event

type tv_1 from treeview within w_pdm_01530
event ue_upscroll ( )
event ue_downscroll ( )
integer x = 14
integer y = 288
integer width = 1573
integer height = 1996
integer taborder = 30
boolean dragauto = true
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean disabledragdrop = false
string picturename[] = {"Custom039!","Custom050!",""}
long picturemaskcolor = 32106727
string statepicturename[] = {"Custom050!"}
long statepicturemaskcolor = 553648127
end type

event ue_upscroll();long h_item = 0

tv_1.SetRedraw (false)

h_item = tv_1.FindItem(FirstVisibleTreeItem!, 0)
h_item = tv_1.FindItem(PreviousTreeItem!,h_item)
if h_item = -1 then
	h_item = tv_1.FindItem(RootTreeItem!, 0)
end if
tv_1.SetFirstVisible(h_item)

tv_1.SelectItem(h_item)

tv_1.SetRedraw (true)


end event

event ue_downscroll();long h_item = 0

tv_1.SetRedraw (false)

h_item = tv_1.FindItem(FirstVisibleTreeItem!, 0)
if h_item = 1 then
	h_item = tv_1.FindItem(ChildTreeItem!,h_item)
else
	h_item = tv_1.FindItem(NextTreeItem!,h_item)
end if
tv_1.SetFirstVisible(h_item)

tv_1.SelectItem(h_item)

tv_1.SetRedraw (true)

end event

event begindrag;// begin drag
TreeViewItem		ltvi_Source

GetItem(handle, ltvi_Source)

dw_insert.reset()

// Make sure only employees are being dragged
If ltvi_Source.Level = 1 Then
	Messagebox("Drag Cancel", "Root Level은 Drag할 수 없읍니다", Stopsign!)
	This.Drag(Cancel!)
Else
	/* 현재의 Handel과 Handle의 값을 구한다 */
	il_DragSource = handle
	il_PrvTarget  = handle
	il_dragparent = finditem(parenttreeitem!, handle)
End If


end event

event dragdrop;// drag drop
String sUsseq, sPinbr, sNo, sOldno, scinbr
Integer				li_Pending 
Long					ll_NewItem, L_parent, LiPos, Lirig
TreeViewItem		ltvi_Target, ltvi_Source, tvi, tvi_prv, tvi_old

If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
If GetItem(il_DragSource, ltvi_Source) = -1 Then Return

/* 기존의 상위품번과 동일하면 Cancel */
sCinbr = ltvi_source.data
Select pinbr into :spinbr
  from pstruc
 where pinbr = :sCinbr;

iBflash = true

GetItem(il_DropTarget, ltvi_target)
If MessageBox("변경", "변경을 원하십니까?  " + &
						 " from " + ltvi_Source.Label + " to " + ltvi_Target.label + &
						"?", Question!, YesNo!) = 2 Then 
	st_1.text = ""
	iBflash = false
	timer(0)	
	setpointer(arrow!)
	return
end if
setpointer(hourglass!)

/* 순번 검색후 자료 저장 */

tv_1.getitem(il_dragparent, tvi_old)
tv_1.getitem(il_droptarget, tvi_prv)
sOldNo = Mid(ltvi_source.label, 2, 5)
sPinbr = tvi_prv.data
sUsseq  = soldno

// Insert the item under the proper parent
sNo = ltvi_source.label
Lipos	= pos(sNo, '[')
Lirig	= pos(sNo, ']')
sNo = Replace(sno, Lipos + 1, 5, susseq)
ltvi_source.label = sNo

st_1.text = "하위 내역을 복사중입니다......!!"
If wf_treeview_seek(this, il_DragSource, tvi_old.data, sOldNo, sPinbr, susseq, ltvi_source.data) = -1 then
	rollback;
	st_1.text = ""
	iBflash = false
	timer(0)	
	setpointer(arrow!)
	return
end if

If wf_update(tvi_old.data, sOldNo, sPinbr, susseq, ltvi_source.data) = -1 then
	Rollback;
	st_1.text = ""
	iBflash = false
	timer(0)	
	setpointer(arrow!)
	return
end if

ltvi_source.label = Left(ltvi_source.label, Lipos) + susseq + &
						 Right(ltvi_source.label, Len(ltvi_source.label) - (Lirig - 1))

// Move the item
// First delete the first item from the TreeView
DeleteItem(il_DragSource)

// 기존 상위의 item의 picture를 변경
long ll_tvi

if FindItem(ChildTreeItem!, il_dragparent) = -1 then
   tvi_old.PictureIndex = 0
   tvi_old.SelectedPictureIndex = 0
	tvi_old.children = false
	SetItem( il_Dragparent, tvi_old )
end if

// 새로운 상위의 item의 picture를 변경
tvi_prv.PictureIndex = 1
tvi_prv.SelectedPictureIndex = 2
SetItem( il_DropTarget, tvi_prv )

// Insert the item under the proper parent
SetNull(ltvi_Source.ItemHandle)
ll_NewItem = InsertItemLast(il_DropTarget, ltvi_Source)

st_1.text = "하위 내역을 변경중입니다......!!"
wf_treeview_make(this, ll_newitem)

/*  Turn off drop highlighting  */
this.SetDropHighlight (0)

// Select the new item
SelectItem(ll_NewItem)

//dw_insert.retrieve(ltvi_source.data)

st_1.text = ''
iBflash = false
setpointer(arrow!)






//----------- 2005.04.28
//// drag drop
//String sUsseq, sPinbr, sNo, sOldno, scinbr
//Integer				li_Pending 
//Long					ll_NewItem, L_parent, LiPos, Lirig
//TreeViewItem		ltvi_Target, ltvi_Source, tvi, tvi_prv, tvi_old
//
//If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
//If GetItem(il_DragSource, ltvi_Source) = -1 Then Return
//
///* 기존의 상위품번과 동일하면 Cancel */
//sCinbr = ltvi_source.data
//Select pinbr into :spinbr
//  from pstruc
// where pinbr = :sCinbr;
//
//iBflash = true
//
//GetItem(il_DropTarget, ltvi_target)
//If MessageBox("변경", "변경을 원하십니까?  " + &
//						 " from " + ltvi_Source.Label + " to " + ltvi_Target.label + &
//						"?", Question!, YesNo!) = 2 Then 
//	st_1.text = ""
//	iBflash = false
//	timer(0)	
//	setpointer(arrow!)
//	return
//end if
//setpointer(hourglass!)
//
///* 순번 검색후 자료 저장 */
//
//tv_1.getitem(il_dragparent, tvi_old)
//tv_1.getitem(il_droptarget, tvi_prv)
//sOldNo = Mid(ltvi_source.label, 2, 5)
//sPinbr = tvi_prv.data
//sUsseq  = soldno
//
//// Insert the item under the proper parent
//sNo = ltvi_source.label
//Lipos	= pos(sNo, '[')
//Lirig	= pos(sNo, ']')
//sNo = Replace(sno, Lipos + 1, 5, susseq)
//ltvi_source.label = sNo
//
//st_1.text = "하위 내역을 복사중입니다......!!"
//If wf_treeview_seek(this, il_DragSource, tvi_old.data, sOldNo, sPinbr, susseq, ltvi_source.data) = -1 then
//	rollback;
//	st_1.text = ""
//	iBflash = false
//	timer(0)	
//	setpointer(arrow!)
//	return
//end if
//
//If wf_update(tvi_old.data, sOldNo, sPinbr, susseq, ltvi_source.data) = -1 then
//	Rollback;
//	st_1.text = ""
//	iBflash = false
//	timer(0)	
//	setpointer(arrow!)
//	return
//end if
//
//ltvi_source.label = Left(ltvi_source.label, Lipos) + susseq + &
//						 Right(ltvi_source.label, Len(ltvi_source.label) - (Lirig - 1))
//
//// Move the item
//// First delete the first item from the TreeView
//DeleteItem(il_DragSource)
//
//// 기존 상위의 item의 picture를 변경
//long ll_tvi
//
//if FindItem(ChildTreeItem!, il_dragparent) = -1 then
//   tvi_old.PictureIndex = 0
//   tvi_old.SelectedPictureIndex = 0
//	tvi_old.children = false
//	SetItem( il_Dragparent, tvi_old )
//end if
//
//// 새로운 상위의 item의 picture를 변경
//tvi_prv.PictureIndex = 1
//tvi_prv.SelectedPictureIndex = 2
//SetItem( il_DropTarget, tvi_prv )
//
//// Insert the item under the proper parent
//SetNull(ltvi_Source.ItemHandle)
//ll_NewItem = InsertItemLast(il_DropTarget, ltvi_Source)
//
//st_1.text = "하위 내역을 변경중입니다......!!"
//wf_treeview_make(this, ll_newitem)
//
///*  Turn off drop highlighting  */
//this.SetDropHighlight (0)
//
//// Select the new item
//SelectItem(ll_NewItem)
//
////dw_insert.retrieve(ltvi_source.data)
//
//st_1.text = ''
//iBflash = false
//setpointer(arrow!)
//
end event

event dragwithin;// drag within
TreeViewItem		ltvi_Over, ltvi_parent

If GetItem(handle, ltvi_Over) = -1 Then
	SetDropHighlight(0)
	il_DropTarget = 0
	Return
End If

il_DropTarget = handle

getitem(il_droptarget, ltvi_parent)
st_1.text = ltvi_over.label + " | " + string(il_droptarget) + " | " + string(il_prvtarget)
//If il_DropTarget <> il_PrvTarget Then
//	SetDropHighlight(il_DropTarget)
//Else
//	SetDropHighlight(0)
//	il_DropTarget = 0
//End If


end event

event key;If key = keydelete! Then
	wf_treeview_delete()
End if
end event

event clicked;// begin drag
TreeViewItem		ltvi_Source
long ll_parent

SetNull(il_crttree)

if GetItem(handle, ltvi_Source) = -1 then return

il_crttree = handle

if ib_any_typing then
	p_mod.triggerevent(clicked!)
End if

is_masterno = ltvi_source.data
dw_insert.retrieve(ltvi_source.data)

ib_any_typing = false
end event

type st_splitbar from u_st_splitbar within w_pdm_01530
integer x = 1586
integer y = 288
integer width = 14
integer height = 1988
boolean bringtotop = true
long backcolor = 8421504
long bordercolor = 33027312
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_pdm_01530
integer x = 992
integer y = 64
integer width = 233
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "요약"
end type

event clicked;if cbx_1.checked  then
	cbx_1.text = '요약'
	dw_insert.Modify("DataWindow.Header.Height=144")	
	dw_insert.Modify("DataWindow.Detail.Height=152")
   dw_insert.modify("pstruc_bomend.protect=0")
	dw_insert.modify("pstruc_pcbloc.protect=0")	
	dw_insert.modify("pstruc_rmks.protect=0")
else
	cbx_1.text = '상세'
	dw_insert.Modify("DataWindow.Header.Height=68")		
	dw_insert.Modify("DataWindow.Detail.Height=72")	
	dw_insert.modify("pstruc_bomend.protect=1")
	dw_insert.modify("pstruc_pcbloc.protect=1")
	dw_insert.modify("pstruc_rmks.protect=1")	
End if


end event

type p_1 from uo_picture within w_pdm_01530
integer x = 3474
integer y = 52
integer width = 178
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\완료처리_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\완료처리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\완료처리_up.gif"
end event

event clicked;call super::clicked;gs_code = trim(dw_head.getitemstring(dw_head.getrow(), 'itnbr'))
if isnull(gs_code) or gs_code = '' then setnull(gs_code)

gs_gubun = '1'
open(w_pdm_01585)
wf_refresh()
end event

type p_2 from uo_picture within w_pdm_01530
integer x = 3291
integer y = 52
integer width = 178
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\일괄복사_up.gif"
end type

event clicked;call super::clicked;gs_code = trim(dw_head.getitemstring(dw_head.getrow(), 'itnbr'))
if isnull(gs_code) or gs_code = '' then setnull(gs_code)

open(w_pdm_01555)

wf_refresh()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄복사_up.gif"
end event

type p_3 from uo_picture within w_pdm_01530
boolean visible = false
integer x = 2377
integer y = 56
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\대량대체_up.gif"
end type

event clicked;call super::clicked;open(w_pdm_01560)

wf_refresh()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\대량대체_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\대량대체_up.gif"
end event

type p_4 from uo_picture within w_pdm_01530
integer x = 3109
integer y = 52
integer width = 178
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\대량복사_up.gif"
end type

event clicked;call super::clicked;

gs_code = trim(dw_head.getitemstring(dw_head.getrow(), 'itnbr'))
if isnull(gs_code) or gs_code = '' then setnull(gs_code)

open(w_pdm_01557)
wf_refresh()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\대량복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\대량복사_up.gif"
end event

type p_5 from uo_picture within w_pdm_01530
boolean visible = false
integer x = 379
integer y = 264
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
boolean enabled = false
string picturename = "C:\erpman\image\공정복사_up.gif"
end type

event clicked;call super::clicked;open(w_pdm_01575)

wf_refresh()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\공정복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\공정복사_up.gif"
end event

type p_6 from uo_picture within w_pdm_01530
boolean visible = false
integer x = 2318
integer y = 136
integer width = 306
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\기술bom_up.gif"
end type

event clicked;call super::clicked;//// 양산이관
//wf_refresh()




open(w_pdm_01577)
wf_refresh()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\기술BOM_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\기술BOM_up.gif"
end event

type cb_ys from commandbutton within w_pdm_01530
boolean visible = false
integer x = 3995
integer y = 2680
integer width = 274
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
boolean enabled = false
string text = "양산이관"
end type

event clicked;string x_itnbr

x_itnbr = trim(dw_head.getitemstring(dw_head.getrow(), 'itnbr'))
gs_code = x_itnbr

open(w_pdm_01530_ys)
wf_refresh()
end event

type p_7 from uo_picture within w_pdm_01530
boolean visible = false
integer x = 2761
integer y = 56
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\양산이관_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\양산이관_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\양산이관_up.gif"
end event

event clicked;call super::clicked;gs_code = trim(dw_head.getitemstring(dw_head.getrow(), 'itnbr'))
if isnull(gs_code) or gs_code = '' then setnull(gs_code)

open(w_pdm_01530_ys)
wf_refresh()
end event

type cbx_2 from checkbox within w_pdm_01530
integer x = 2967
integer y = 232
integer width = 311
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 134217729
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;long ll_cnt, i
string ls_chk



ll_cnt = dw_insert.rowcount()
if ll_cnt < 1 then return

if this.checked then 
	ls_chk = 'Y'
else
	ls_chk = 'N'
end if
	
for i = 1 to ll_cnt step 1
	dw_insert.object.chk[i] = ls_chk
next
	
	
	
	
	
	
	
	
	
	

end event

type rr_2 from roundrectangle within w_pdm_01530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3712
integer y = 24
integer width = 910
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdm_01530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2734
integer y = 24
integer width = 951
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_qa02_00050_popup01.srw
$PBExportComments$** 수정불합격 처리
forward
global type w_qa02_00050_popup01 from w_inherite
end type
type dw_head from u_key_enter within w_qa02_00050_popup01
end type
type st_splitbar from u_st_splitbar within w_qa02_00050_popup01
end type
type p_6 from uo_picture within w_qa02_00050_popup01
end type
type tv_1 from treeview within w_qa02_00050_popup01
end type
type p_1 from picture within w_qa02_00050_popup01
end type
end forward

global type w_qa02_00050_popup01 from w_inherite
string tag = "생산BOM등록"
integer width = 3465
integer height = 1648
string title = "BOM 조회"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
dw_head dw_head
st_splitbar st_splitbar
p_6 p_6
tv_1 tv_1
p_1 p_1
end type
global w_qa02_00050_popup01 w_qa02_00050_popup01

type variables
Long il_dragsource, il_droptarget, il_prvtarget, il_dragparent, il_crttree
String iSlabel[], iSdata[]
Integer iIpic[], iISel[], iIlevel[], Iicnt
Boolean iBchild[], iBflash
Str_pstruc pstruc_str
String is_masterno   // 현재품목의 상위품번

end variables

forward prototypes
public function integer wf_treeview_seek (treeview ltvi, long ahandle, string old_pinbr, string old_usseq, string new_pinbr, string new_cinbr, string arg_cinbr)
public subroutine wf_treeview_make (treeview ltvi, long ahandle)
public function integer wf_refresh ()
public subroutine wf_treeview (string sitem)
end prototypes

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
			
  If sqlca.sqlcode <> 0 Then
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

public subroutine wf_treeview (string sitem);/* Treeview내역을 생성 */
Datastore ds_bom
Treeviewitem tvi
String sToday
Long 		l_row, L_gbn, H_item, L_parent, L_gbn_b
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
//ds_bom.dataobject = "d_pdm_01530_2"  d_qa02_00051_bom
ds_bom.dataobject = "d_qa02_00051_bom" 
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
		 tvi.label = '['+ds_bom.object.cinbr[L_row]+']'+ sitdsc 
	 else
		 tvi.label = '['+ds_bom.object.cinbr[L_row]+']'+ sitdsc + &
		             ' (' + ds_bom.object.pcb_name[L_row] + ')'
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
/*	 H_item = tv_1.insertitemlast(L_parent, tvi)			// Root의 내용을 Sort를 하지않는 경우 */
Next

H_item = tv_1.FindItem(RootTreeItem!, 0) 
			tv_1.Expanditem(H_item)

Destroy ds_bom

return  

end subroutine

on w_qa02_00050_popup01.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.st_splitbar=create st_splitbar
this.p_6=create p_6
this.tv_1=create tv_1
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.st_splitbar
this.Control[iCurrent+3]=this.p_6
this.Control[iCurrent+4]=this.tv_1
this.Control[iCurrent+5]=this.p_1
end on

on w_qa02_00050_popup01.destroy
call super::destroy
destroy(this.dw_head)
destroy(this.st_splitbar)
destroy(this.p_6)
destroy(this.tv_1)
destroy(this.p_1)
end on

event open;call super::open;f_window_center(This)

st_splitbar.of_Register(tv_1, st_splitbar.LEFT)
st_splitbar.of_Register(dw_insert, st_splitbar.RIGHT)

postevent("ue_open")
end event

event ue_open;call super::ue_open;dw_head.settransobject(sqlca)
dw_insert.settransobject(sqlca)

dw_head.Reset()
dw_head.InsertRow(0)

String ls_itdsc ,ls_ispec ,ls_jijil

If gs_gubun > '' Then
	SELECT "ITEMAS"."ITDSC", 
			 "ITEMAS"."ISPEC", 
			 "ITEMAS"."JIJIL"
	  INTO :ls_ItDsc,   		 
			 :ls_Ispec, 		
			 :ls_Jijil
	  FROM "ITEMAS"
	 WHERE "ITEMAS"."ITNBR" = :gs_gubun AND	"ITEMAS"."USEYN" = '0' ;
	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
		Return
	END IF
	
	dw_head.Object.itnbr[1] = gs_gubun
	dw_head.Object.itdsc[1] = ls_itdsc
End If

dw_insert.reset()

is_masterno = gs_gubun
wf_treeview(gs_gubun)
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00050_popup01
integer x = 1330
integer y = 196
integer width = 2089
integer height = 1276
string dataobject = "d_qa02_00050_popup01_2"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::doubleclicked;call super::doubleclicked;If row < 1 Then 
	f_message_chk(36,'')
	Return 
End If

gs_code     = dw_insert.GetItemString(row, "itnbr")
gs_codename = dw_insert.GetItemString(row, "cvcod")

Close(Parent)
end event

event dw_insert::clicked;call super::clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00050_popup01
boolean visible = false
integer x = 2725
integer y = 28
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00050_popup01
boolean visible = false
integer x = 2551
integer y = 28
boolean enabled = false
end type

event p_addrow::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event p_addrow::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_search from w_inherite`p_search within w_qa02_00050_popup01
boolean visible = false
integer x = 3369
integer y = 2428
end type

type p_ins from w_inherite`p_ins within w_qa02_00050_popup01
boolean visible = false
integer x = 3991
integer y = 2432
end type

type p_exit from w_inherite`p_exit within w_qa02_00050_popup01
integer x = 3246
integer y = 28
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_qa02_00050_popup01
boolean visible = false
integer x = 3072
integer y = 28
end type

type p_print from w_inherite`p_print within w_qa02_00050_popup01
boolean visible = false
integer x = 3584
integer y = 2428
end type

type p_inq from w_inherite`p_inq within w_qa02_00050_popup01
boolean visible = false
integer x = 3781
integer y = 2428
end type

type p_del from w_inherite`p_del within w_qa02_00050_popup01
boolean visible = false
integer x = 4219
integer y = 2428
end type

type p_mod from w_inherite`p_mod within w_qa02_00050_popup01
boolean visible = false
integer x = 2898
integer y = 28
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_qa02_00050_popup01
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00050_popup01
end type

type cb_ins from w_inherite`cb_ins within w_qa02_00050_popup01
end type

type cb_del from w_inherite`cb_del within w_qa02_00050_popup01
end type

type cb_inq from w_inherite`cb_inq within w_qa02_00050_popup01
end type

type cb_print from w_inherite`cb_print within w_qa02_00050_popup01
end type

type st_1 from w_inherite`st_1 within w_qa02_00050_popup01
integer x = 1422
integer y = 2484
integer width = 1582
string text = ""
end type

type cb_can from w_inherite`cb_can within w_qa02_00050_popup01
integer x = 2117
integer y = 2784
end type

type cb_search from w_inherite`cb_search within w_qa02_00050_popup01
end type







type gb_button1 from w_inherite`gb_button1 within w_qa02_00050_popup01
integer x = 910
integer y = 3244
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00050_popup01
end type

type dw_head from u_key_enter within w_qa02_00050_popup01
event ue_key pbm_dwnkey
integer x = 18
integer y = 20
integer width = 2295
integer height = 172
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_qa02_00050_popup01_1"
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

event itemchanged;call super::itemchanged;String  sItnbr,sItDsc,sIspec,sjijil,sispeccode
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
		SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."JIJIL"
		  INTO :sItDsc,   		 :sIspec, 		:sJijil
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
         p_can.triggerevent(clicked!)
			Return 1
		END IF
	
		SetItem(nRow,"itdsc",   sItDsc)
		//SetItem(nRow,"ispec",   sIspec)
		//SetItem(nRow,"jijil",   sJijil)
		
		is_masterno = sitnbr
		gs_codename2 = sitnbr
		wf_treeview(sitnbr)
End Choose
end event

type st_splitbar from u_st_splitbar within w_qa02_00050_popup01
integer x = 1317
integer y = 196
integer width = 14
integer height = 1276
boolean bringtotop = true
long backcolor = 8421504
long bordercolor = 33027312
boolean focusrectangle = false
end type

type p_6 from uo_picture within w_qa02_00050_popup01
boolean visible = false
integer x = 2130
integer y = 32
integer width = 306
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
boolean enabled = false
string picturename = "C:\erpman\image\기술BOM_up.gif"
end type

event clicked;call super::clicked;open(w_pdm_01577)

wf_refresh()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\기술BOM_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\기술BOM_up.gif"
end event

type tv_1 from treeview within w_qa02_00050_popup01
integer x = 14
integer y = 196
integer width = 1307
integer height = 1276
integer taborder = 30
boolean dragauto = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = styleraised!
boolean linesatroot = true
boolean disabledragdrop = false
string picturename[] = {"Custom039!","Custom050!",""}
long picturemaskcolor = 32106727
string statepicturename[] = {"Custom050!"}
long statepicturemaskcolor = 553648127
end type

event begindrag;//// begin drag
//TreeViewItem		ltvi_Source
//
//GetItem(handle, ltvi_Source)
//
//dw_insert.reset()
//
//// Make sure only employees are being dragged
//If ltvi_Source.Level = 1 Then
//	Messagebox("Drag Cancel", "Root Level은 Drag할 수 없읍니다", Stopsign!)
//	This.Drag(Cancel!)
//Else
//	/* 현재의 Handel과 Handle의 값을 구한다 */
//	il_DragSource = handle
//	il_PrvTarget  = handle
//	il_dragparent = finditem(parenttreeitem!, handle)
//End If
//
//
end event

event dragdrop;//// drag drop
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

event clicked;// begin drag
TreeViewItem		ltvi_Source
long   ll_parent ,i
String ls_itnbr,ls_cinbr='', old_select, new_select, where_clause

SetNull(il_crttree)

if GetItem(handle, ltvi_Source) = -1 then return

SetPointer(Hourglass!)
il_crttree = handle
is_masterno = ltvi_source.data

ls_itnbr = ltvi_source.data

dw_insert.retrieve(ls_itnbr)

SetPointer(Arrow!)


ib_any_typing = false
end event

type p_1 from picture within w_qa02_00050_popup01
integer x = 3072
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\선택_up.gif"
boolean focusrectangle = false
end type

event clicked;Long ll_row

ll_Row = dw_insert.GetRow()

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code     = dw_insert.GetItemString(ll_Row, "itnbr")
gs_codename = dw_insert.GetItemString(ll_Row, "cvcod")

dw_insert.SaveAs("", Clipboard!, False)
Close(Parent)
end event


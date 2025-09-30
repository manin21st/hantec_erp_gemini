$PBExportHeader$w_pdt_06600.srw
$PBExportComments$설비/계측기 분류코드 등록**
forward
global type w_pdt_06600 from w_inherite
end type
type dw_1 from datawindow within w_pdt_06600
end type
type rr_1 from roundrectangle within w_pdt_06600
end type
end forward

global type w_pdt_06600 from w_inherite
string title = "계측기 분류코드 등록"
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_06600 w_pdt_06600

type variables

end variables

forward prototypes
public subroutine wf_reset ()
public subroutine wf_modify (string sgub)
public function integer wf_required_chk (integer i)
end prototypes

public subroutine wf_reset ();dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(true)
end subroutine

public subroutine wf_modify (string sgub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull

setnull(snull)

IF sgub = 'L' THEN
	dw_1.Modify("large.TabSequence = 0")
	dw_1.Modify("mid.TabSequence = 0")
//	dw_1.Modify("large.BackGround.Color= 79741120") 
//	dw_1.Modify("mid.BackGround.Color= 79741120") 

//	dw_1.SetItem(1, "sittyp", snull)
	dw_1.SetItem(1, "large", snull)
	dw_1.SetItem(1, "mid", snull)
	dw_1.SetItem(1, "large_nm", snull)
	dw_1.SetItem(1, "mid_nm", snull)

   dw_insert.DataObject ="d_pdt_06600" 
   dw_insert.SetTransObject(SQLCA)
ELSEIF sgub = 'M' THEN
	dw_1.Modify("large.TabSequence = 30")
	dw_1.Modify("mid.TabSequence = 0")
//	dw_1.Modify("large.BackGround.Color= 65535") 
//	dw_1.Modify("mid.BackGround.Color= 79741120") 

	dw_1.SetItem(1, "large", snull)
	dw_1.SetItem(1, "mid", snull)
	dw_1.SetItem(1, "large_nm", snull)
	dw_1.SetItem(1, "mid_nm", snull)

   dw_insert.DataObject ="d_pdt_06600_1" 
   dw_insert.SetTransObject(SQLCA)
ELSEIF sgub = 'S' THEN
	dw_1.Modify("large.TabSequence = 0")
	dw_1.Modify("mid.TabSequence = 40")
//	dw_1.Modify("large.BackGround.Color= 79741120") 
//	dw_1.Modify("mid.BackGround.Color= 65535") 

	dw_1.SetItem(1, "large", snull)
	dw_1.SetItem(1, "mid", snull)
	dw_1.SetItem(1, "large_nm", snull)
	dw_1.SetItem(1, "mid_nm", snull)

   dw_insert.DataObject ="d_pdt_06600_2" 
   dw_insert.SetTransObject(SQLCA)
END IF


end subroutine

public function integer wf_required_chk (integer i);string s_lms

if dw_1.AcceptText() = -1 then return  -1

s_lms = dw_1.GetItemString(1,'lmsgub')

if dw_insert.AcceptText() = -1 then return -1

if s_lms = 'L' then

	if isnull(dw_insert.GetItemString(i,'buncd')) or &
		dw_insert.GetItemString(i,'buncd') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 대분류코드]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('buncd')
		dw_insert.SetFocus()
		return -1		
	end if	

elseif s_lms = 'M' then

	if isnull(dw_insert.GetItemString(i,'mbuncd')) or &
		dw_insert.GetItemString(i,'mbuncd') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 중분류코드]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('mbuncd')
		dw_insert.SetFocus()
		return -1		
	end if	

elseif s_lms = 'S' then

	if isnull(dw_insert.GetItemString(i,'stcls')) or &
		dw_insert.GetItemString(i,'stcls') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 품목분류코드]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('stcls')
		dw_insert.SetFocus()
		return -1		
	end if	

end if

return 1
end function

on w_pdt_06600.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_06600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()


p_inq.triggerevent(clicked!)
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

type dw_insert from w_inherite`dw_insert within w_pdt_06600
integer x = 96
integer y = 236
integer width = 4489
integer height = 2032
integer taborder = 30
string dataobject = "d_pdt_06600"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rowfocuschanged;dw_insert.SetRowFocusIndicator(Hand!)
end event

event dw_insert::itemchanged;Int lRow,lReturnRow
String srfgub,snull, sHsno

SetNull(snull)

lRow  = this.GetRow()	
srfgub = THIS.GETTEXT()								

IF this.GetColumnName() = "buncd" THEN
	IF len(srfgub) <> 2 Then
      messagebox("확인", "대분류코드 자릿수는 2자리 입니다!!")
		this.SetItem(lRow, "buncd", sNull)
		RETURN  1
	END IF
		
	lReturnRow = This.Find("buncd = '"+srfgub+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[대분류코드]') 
		this.SetItem(lRow, "buncd", sNull)
		RETURN  1
	END IF
ELSEIF this.GetColumnName() = "mbuncd" THEN
	IF len(srfgub) <> 2 Then
      messagebox("확인", "중분류코드 자릿수는 2자리 입니다!!")
		this.SetItem(lRow, "mbuncd", sNull)
		RETURN  1
	END IF
		
	lReturnRow = This.Find("mbuncd = '"+srfgub+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[중분류코드]') 
		this.SetItem(lRow, "mbuncd", sNull)
		RETURN  1
	END IF
ELSEIF this.GetColumnName() = "stcls" THEN
	IF len(srfgub) <> 2 Then
      messagebox("확인", "분류코드 자릿수는 2자리 입니다!!")
		this.SetItem(lRow, "stcls", sNull)
		RETURN  1
	END IF
	lReturnRow = This.Find("stcls = '"+srfgub+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[분류코드]') 
		this.SetItem(lRow, "stcls", sNull)
		RETURN  1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06600
boolean visible = false
integer x = 4407
integer y = 3296
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06600
boolean visible = false
integer x = 4233
integer y = 3296
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdt_06600
boolean visible = false
integer x = 3538
integer y = 3296
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdt_06600
integer x = 3744
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;int  i, il_currow, il_rowcount
string s_gub, s_lms, s_large, s_mid, get_nm

if dw_1.AcceptText() = -1 then return 

s_lms = dw_1.GetItemString(1,'lmsgub')
s_gub = dw_1.GetItemString(1,'sittyp')

if isnull(s_gub) or s_gub = "" then
	f_message_chk(30,'[구분]')
	dw_1.SetColumn('sittyp')
	dw_1.SetFocus()
	return
end if	

if s_lms = 'L' then
	
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
	
	il_currow = il_currow + 1
	dw_insert.InsertRow(il_currow)
	
	dw_insert.setitem(il_currow, 'kegbn', s_gub )
	
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetColumn('buncd')
	dw_insert.SetFocus()
	
elseif s_lms = 'M' then
	
	s_large = dw_1.GetItemString(1,'large')
	
	if isnull(s_large) or s_large = "" then
		f_message_chk(30,'[대분류코드]')
    	dw_1.SetColumn('large')
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
	
	il_currow = il_currow + 1
	dw_insert.InsertRow(il_currow)
	
	dw_insert.setitem(il_currow, 'kegbn', s_gub )
   dw_insert.setitem(il_currow, 'buncd', s_large )
		
//   SELECT "ITNCT"."PDTGU"  
//     INTO :get_nm  
//     FROM "ITNCT"  
//    WHERE ( "ITNCT"."ITTYP" = :s_gub ) AND  
//          ( "ITNCT"."ITCLS" = :s_large ) AND  
//          ( "ITNCT"."LMSGU" = 'L' )   ;
//
//   dw_insert.setitem(il_currow, 'pdtgu', get_nm )
//  
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetColumn('mbuncd')
	dw_insert.SetFocus()
elseif s_lms = 'S' then
	s_mid = dw_1.GetItemString(1,'mid')
	s_large = dw_1.GetItemString(1,'large')
	
	if isnull(s_mid) or s_mid = "" then
		f_message_chk(30,'[중분류코드]')
    	dw_1.SetColumn('mid')
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
	
	il_currow = il_currow + 1
	dw_insert.InsertRow(il_currow)
	
	dw_insert.setitem(il_currow, 'kegbn', s_gub )
   dw_insert.setitem(il_currow, 'buncd', s_mid )
		
//   SELECT "ITNCT"."PDTGU"  
//     INTO :get_nm  
//     FROM "ITNCT"  
//    WHERE ( "ITNCT"."ITTYP" = :s_gub ) AND  
//          ( "ITNCT"."ITCLS" = :s_large ) AND  
//          ( "ITNCT"."LMSGU" = 'L' )   ;
//
//   dw_insert.setitem(il_currow, 'pdtgu', get_nm )
   dw_insert.ScrollToRow(il_currow)
	dw_insert.SetColumn('stcls')
	dw_insert.SetFocus()
end if

end event

type p_exit from w_inherite`p_exit within w_pdt_06600
end type

type p_can from w_inherite`p_can within w_pdt_06600
end type

event p_can::clicked;call super::clicked;wf_modify('L')
dw_1.SetItem(1, "lmsgub", 'L')
dw_1.SetItem(1, "sittyp", 'Y')

wf_reset()
p_inq.triggerevent(clicked!)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_06600
boolean visible = false
integer x = 3712
integer y = 3296
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdt_06600
integer x = 3570
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_lms, s_gub, s_gub1, s_large, s_mid

if dw_1.AcceptText() = -1 then return 

s_lms = dw_1.GetItemString(1,'lmsgub')
s_gub = trim(dw_1.GetItemString(1,'sittyp'))

if isnull(s_gub) or s_gub = "" then
	f_message_chk(30,'[구분]')
	dw_1.Setcolumn('sittyp')
	dw_1.SetFocus()
	return
end if	

if s_lms = 'L' then
	if dw_insert.Retrieve(s_gub) <= 0 then 
		p_ins.Setfocus()
	else
		dw_insert.SetFocus()
		dw_insert.SetColumn('lmsgu')
	end if	
elseif s_lms = 'M' then
	s_large = dw_1.GetItemString(1,'large')
	
	if isnull(s_large) or s_large = "" then
		f_message_chk(30,'[대분류코드]')
   	dw_1.Setcolumn('large')
		dw_1.SetFocus()
		return
	end if	

	if dw_insert.Retrieve(s_gub, s_large) <= 0 then 
		p_ins.Setfocus()
	else
		dw_insert.SetFocus()
		dw_insert.SetColumn('lmsgu')
	end if	
else
	s_large = dw_1.GetItemString(1,'large')
	
//	if isnull(s_large) or s_large = "" then
//		f_message_chk(30,'[중분류코드]')
//   	dw_1.Setcolumn('large')
//		dw_1.SetFocus()
//		return
//	end if	
//
	s_mid = dw_1.GetItemString(1,'mid')
	
	if isnull(s_mid) or s_mid = "" then
		f_message_chk(30,'[중분류코드]')
   	dw_1.Setcolumn('mid')
		dw_1.SetFocus()
		return
	end if	

//   s_mid = s_large + s_mid

	if dw_insert.Retrieve(s_gub, s_mid) <= 0 then 
		p_ins.Setfocus()
	else
		dw_insert.SetFocus()
		dw_insert.SetColumn('lmsgu')
	end if	
end if	
	
ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_pdt_06600
end type

event p_del::clicked;call super::clicked;long i, irow, irow2
long get_count, i_seq
string s_lms, s_itcls, s_gub

dw_insert.AcceptText()
dw_1.AcceptText()

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
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

s_lms   = dw_1.GetItemString(1,'lmsgub')
s_gub   = dw_1.GetItemString(1,'sittyp')
s_itcls = dw_insert.GetItemString(dw_insert.getrow(),'buncd')

if f_msg_delete() = -1 then return

if s_lms = 'L' then 
	s_itcls = s_itcls + '%'
   SELECT COUNT(*)
     INTO :get_count  
     FROM "MITNCT"  
    WHERE ( "MITNCT"."KEGBN" = :s_gub ) AND  
          ( "MITNCT"."BUNCD" LIKE :s_itcls ) AND  
          ( "MITNCT"."LMSGU" <> 'L' )   ;

   IF get_count > 0 then 
		messagebox("삭제불가", "삭제하시려면 먼저 중분류 자료부터 삭제하세요!!")
	   return 
   END IF
elseif s_lms = 'M' then 	
//   i_seq = dw_insert.GetItemNumber(dw_insert.getrow(),'seq')
	s_itcls = s_itcls + '%'
	
//   if i_seq > 0 then	
//		messagebox("삭제불가", "순번이 0 보다 크면 삭제할 수 없습니다!!")
//	   return 
//   END IF
   
	DELETE FROM "MITNCT"  
   WHERE ( "MITNCT"."KEGBN" = :s_gub ) AND  
         ( "MITNCT"."BUNCD" like :s_itcls ) AND  
         ( "MITNCT"."LMSGU" = 'S' )   ;
end if	
   
dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_mod from w_inherite`p_mod within w_pdt_06600
end type

event p_mod::clicked;call super::clicked;long i
string s_lms, s_itcls, s_ittyp, s_pdtgu

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
s_ittyp = dw_1.GetItemString(1,'sittyp')
s_lms   = dw_1.GetItemString(1,'lmsgub')

//if s_lms = 'L' and ( s_ittyp = '1' or s_ittyp = '2' ) then   //완제품, 반제품일 경우
//	FOR i=1 TO dw_insert.rowcount()
//       if dw_insert.getitemstring(i, 'flag') = '1' then
//			 s_itcls = dw_insert.getitemstring(i, 'itcls')   
//			 s_pdtgu = dw_insert.getitemstring(i, 'pdtgu')   
//			 
//			 s_itcls = s_itcls + '%'
//			 
//          UPDATE "ITNCT"  
//			    SET "PDTGU" = :s_pdtgu  
//			  WHERE ( "ITNCT"."ITTYP" = :s_ittyp ) AND  
//					  ( "ITNCT"."ITCLS" LIKE :s_itcls ) AND  
//					  ( "ITNCT"."LMSGU" <> 'L' )   ;
//       end if	
//   NEXT
if s_lms = 'L' then
	for i = 1 to dw_insert.rowcount()
		dw_insert.setitem(i,'lmsgu', s_lms)
	next
elseif s_lms = 'M' then 
	FOR i=1 TO dw_insert.rowcount()
       s_itcls = dw_insert.getitemstring(i, 'lbuncd') + dw_insert.getitemstring(i, 'mbuncd')
	    dw_insert.setitem(i, 'buncd', s_itcls)
		 dw_insert.setitem(i, 'lmsgu', s_lms)
   NEXT
elseif s_lms = 'S' then 
	FOR i=1 TO dw_insert.rowcount()
       s_itcls = dw_insert.getitemstring(i, 'lbuncd') + dw_insert.getitemstring(i, 'stcls')
	    dw_insert.setitem(i, 'buncd', s_itcls)
       dw_insert.setitem(i, 'lmsgu', s_lms)
   NEXT
end if

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_pdt_06600
integer x = 2683
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06600
integer x = 1600
integer y = 3292
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06600
integer x = 1253
integer y = 3292
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_06600
integer x = 1961
integer y = 3292
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06600
integer x = 896
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_pdt_06600
integer x = 1984
integer y = 2824
end type

type st_1 from w_inherite`st_1 within w_pdt_06600
end type

type cb_can from w_inherite`cb_can within w_pdt_06600
integer x = 2322
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_pdt_06600
integer x = 2331
integer y = 2820
end type





type gb_10 from w_inherite`gb_10 within w_pdt_06600
integer x = 96
integer y = 3472
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06600
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06600
end type

type dw_1 from datawindow within w_pdt_06600
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 12
integer width = 3447
integer height = 212
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_06600_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string s_pumgu, sgub, snull, sget_name, s_large, s_mid, get_nm, get_nm2

setnull(snull)

IF this.AcceptText() <> 1 THEN Return 

IF this.GetColumnName() ="sittyp" THEN
	   s_pumgu = this.GetText()

		this.SetItem(1,"large",snull)
		this.SetItem(1,"large_nm",snull)
		this.SetItem(1,"mid",snull)
		this.SetItem(1,"mid_nm",snull)
   	sgub = this.GetItemString(1, 'lmsgub') 
		if sgub = 'L' then 
//         cb_inq.TriggerEvent(Clicked!)
           if dw_insert.Retrieve(s_pumgu) <= 0 then 
				  p_ins.Setfocus()
			  end if
      else
   		wf_reset()
		end if	
		
		   
ELSEIF this.GetColumnName() ="lmsgub" THEN
	sgub = this.GetText()
   wf_modify(sgub)
	s_pumgu = this.GetItemString(1, 'sittyp' )
	
	if sgub = 'L' then 
         if dw_insert.Retrieve(s_pumgu) <= 0 then 
				p_ins.Setfocus()
			end if      
   else
   		wf_reset()
	end if	
	

ELSEIF this.GetColumnName() ="large" THEN
	s_large = this.GetText()
  	s_pumgu = this.GetItemString(1, 'sittyp' )

	
	IF s_large = "" or isnull(s_large) then
		this.SetItem(1,"large_nm",snull)
		wf_reset()
   	return  
	END IF

	 SELECT "MITNCT"."BUNNAM"  
     INTO :get_nm   
     FROM "MITNCT"  
    WHERE ( "MITNCT"."KEGBN" = :s_pumgu ) AND  
          ( "MITNCT"."BUNCD" = :s_large )   ;

	IF SQLCA.SQLCODE <> 0 then 
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.setitem(1, "large", snull)
			this.setitem(1, "large_nm", snull)
		END IF
		Return 1	
   ELSE
		this.setitem(1, "large_nm", get_nm)
      p_inq.TriggerEvent(Clicked!)
   END IF	
	
ELSEIF this.GetColumnName() ="mid" THEN
   
	s_mid = this.GetText()
 	s_pumgu = this.GetItemString(1, 'sittyp' )
 
	IF s_mid = "" or isnull(s_mid) then
		this.SetItem(1,"mid_nm",snull)
		wf_reset()
   	return  
	END IF
	
	SELECT "MITNCT"."BUNNAM"  
     INTO :get_nm   
     FROM "MITNCT"  
    WHERE ( "MITNCT"."KEGBN" = :s_pumgu ) AND  
          ( "MITNCT"."BUNCD" = :s_mid )   ;

	IF SQLCA.SQLCODE <> 0 then 
		this.triggerevent(rbuttondown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.setitem(1, "mid", snull)
			this.setitem(1, "mid_nm", snull)
      END IF
      RETURN 1
   ELSE
		s_large = left(s_mid, 2)     // 설비 계측기 대분류 
				
		SELECT "MITNCT"."BUNNAM"  
		  INTO :get_nm2   
		  FROM "MITNCT"  
		 WHERE ( "MITNCT"."KEGBN" = :s_pumgu ) AND  
				 ( "MITNCT"."BUNCD" = :s_large )   ;
      
		if sqlca.sqlcode <> 0 then 
			f_message_chk(52, "")
			this.SetItem(1, "large", snull)
			this.SetItem(1, "large_nm", snull)
			this.SetItem(1, "mid", snull)
			this.SetItem(1, "mid_nm", snull)
   		wf_reset()
			return 1 
		end if	
	
		this.SetItem(1, "large", s_large)
		this.SetItem(1, "large_nm", get_nm2)
		this.setitem(1, "mid_nm", get_nm)
      p_inq.TriggerEvent(Clicked!)
	END IF	
END IF	
end event

event itemerror;return 1
end event

event rbuttondown;string snull

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)
setnull(snull)

IF this.AcceptText() <> 1 THEN Return 

IF this.GetColumnName() ="large" THEN
   
	gs_gubun = this.getitemstring(1, 'sittyp')
	
	open(w_mitnct_l_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
	
	this.SetItem(1, "sittyp", gs_gubun)
	this.SetItem(1, "large", gs_Code)
	this.SetItem(1, "large_nm", gs_Codename)
   p_inq.TriggerEvent(Clicked!)
   return 1 
ELSEIF this.GetColumnName() ="mid" THEN

	gs_gubun = this.getitemstring(1, 'sittyp')
	
	open(w_mitnct_m_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN

	string s_large, get_nm
	
	s_large = left(gs_code, 2 )    // 설비,계측기 대분류 -- 4자리 

	
   SELECT "MITNCT"."BUNNAM"  
     INTO :get_nm  
     FROM "MITNCT"  
    WHERE ( "MITNCT"."KEGBN" = :gs_gubun ) AND  
          ( "MITNCT"."BUNCD" = :s_large )   ; 
		
   if sqlca.sqlcode <> 0 then 
		f_message_chk(52, "")
//		this.SetItem(1, "sittyp", snull)
		this.SetItem(1, "large", snull)
		this.SetItem(1, "large_nm", snull)
		this.SetItem(1, "mid", snull)
		this.SetItem(1, "mid_nm", snull)
		wf_reset()
	   return 1 
	end if	
	
	this.SetItem(1, "sittyp", gs_gubun)
	this.SetItem(1, "large", s_large)
	this.SetItem(1, "large_nm", get_nm)
	this.SetItem(1, "mid", gs_code)
	this.SetItem(1, "mid_nm", gs_Codename)
   p_inq.TriggerEvent(Clicked!)
   return 1 
END IF	
end event

type rr_1 from roundrectangle within w_pdt_06600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 228
integer width = 4530
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type


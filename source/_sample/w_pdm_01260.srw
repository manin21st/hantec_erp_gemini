$PBExportHeader$w_pdm_01260.srw
$PBExportComments$** 분류코드 등록
forward
global type w_pdm_01260 from w_inherite
end type
type dw_1 from datawindow within w_pdm_01260
end type
type rr_1 from roundrectangle within w_pdm_01260
end type
type rr_2 from roundrectangle within w_pdm_01260
end type
end forward

global type w_pdm_01260 from w_inherite
string title = "분류코드 등록"
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01260 w_pdm_01260

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
protected subroutine wf_modify (string sgub)
end prototypes

public function integer wf_required_chk (integer i);string s_lms

if dw_1.AcceptText() = -1 then return  -1

s_lms = dw_1.GetItemString(1,'lmsgub')

if dw_insert.AcceptText() = -1 then return -1

if s_lms = 'L' then

	if isnull(dw_insert.GetItemString(i,'itcls')) or &
		dw_insert.GetItemString(i,'itcls') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 대분류코드]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('itcls')
		dw_insert.SetFocus()
		return -1		
	end if	

elseif s_lms = 'M' then

	if isnull(dw_insert.GetItemString(i,'mtcls')) or &
		dw_insert.GetItemString(i,'mtcls') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 중분류코드]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('mtcls')
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

public subroutine wf_reset ();dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(true)
end subroutine

protected subroutine wf_modify (string sgub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull

setnull(snull)

//대분류
IF sgub = 'L' THEN
	dw_1.Modify("large.TabSequence = 0")
	dw_1.Modify("mid.TabSequence = 0")
	dw_1.Modify("p_l.visible = 0") 
	dw_1.Modify("p_j.visible = 0") 

	dw_1.SetItem(1, "sittyp", snull)
	dw_1.SetItem(1, "large", snull)
	dw_1.SetItem(1, "mid", snull)
	dw_1.SetItem(1, "large_nm", snull)
	dw_1.SetItem(1, "mid_nm", snull)

   dw_insert.DataObject ="d_pdm_01260" 
   dw_insert.SetTransObject(SQLCA)
//중분류
ELSEIF sgub = 'M' THEN
	dw_1.Modify("large.TabSequence = 30")
	dw_1.Modify("mid.TabSequence = 0")
	dw_1.Modify("p_l.visible = 1") 
	dw_1.Modify("p_j.visible = 0") 

	dw_1.SetItem(1, "large", snull)
	dw_1.SetItem(1, "mid", snull)
	dw_1.SetItem(1, "large_nm", snull)
	dw_1.SetItem(1, "mid_nm", snull)

   dw_insert.DataObject ="d_pdm_01260_1" 
   dw_insert.SetTransObject(SQLCA)
//소분류
ELSEIF sgub = 'S' THEN
	dw_1.Modify("large.TabSequence = 0")
	dw_1.Modify("mid.TabSequence = 40")
	dw_1.Modify("p_l.visible = 0") 
	dw_1.Modify("p_j.visible = 1") 

	dw_1.SetItem(1, "large", snull)
	dw_1.SetItem(1, "mid", snull)
	dw_1.SetItem(1, "large_nm", snull)
	dw_1.SetItem(1, "mid_nm", snull)

   dw_insert.DataObject ="d_pdm_01260_2" 
   dw_insert.SetTransObject(SQLCA)
END IF


end subroutine

on w_pdm_01260.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_pdm_01260.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

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

type dw_insert from w_inherite`dw_insert within w_pdm_01260
integer x = 64
integer y = 236
integer width = 4503
integer height = 2056
integer taborder = 30
string dataobject = "d_pdm_01260"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_key;call super::ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case KeyEnter! 
		if this.getcolumnname() = "auto" then
			if this.rowcount() = this.getrow() then
				p_ins.postevent(clicked!)
				return 1
			end if
		end if
end choose


end event

event dw_insert::itemchanged;Int lRow,lReturnRow
String srfgub,snull, sHsno

SetNull(snull)

lRow  = this.GetRow()	
srfgub = THIS.GETTEXT()								

//==================================================================================
Choose Case this.GetColumnName()
	Case	"itcls" 
		IF len(srfgub) < 2 Then
   		   	messagebox("확인", "대분류코드 자릿수는 2자리 입니다!!")
			this.SetItem(lRow, "itcls", sNull)
			RETURN  1
		END IF
		
		lReturnRow = This.Find("itcls = '"+srfgub+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[대분류코드]') 
			this.SetItem(lRow, "itcls", sNull)
			RETURN  1
		END IF
	Case	"mtcls" 
		IF len(srfgub) < 2 Then
      		messagebox("확인", "중분류코드 자릿수는 2자리 입니다!!")
			this.SetItem(lRow, "mtcls", sNull)
			RETURN  1
		END IF
		
		lReturnRow = This.Find("mtcls = '"+srfgub+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[중분류코드]') 
			this.SetItem(lRow, "mtcls", sNull)
			RETURN  1
		END IF
	Case	"stcls" 
		IF len(srfgub) < 3 Then
      		messagebox("확인", "품목분류코드 자릿수는 3자리 입니다!!")
			this.SetItem(lRow, "stcls", sNull)
			RETURN  1
		END IF
		lReturnRow = This.Find("stcls = '"+srfgub+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[품목분류코드]') 
			this.SetItem(lRow, "stcls", sNull)
			RETURN  1
		END IF
	Case	"pdtgu" 
		this.SetItem(lRow, "flag", '1')  //변경시 flag에 값을 넣어줌
	Case	"etcnbr" 
   		IF srfgub = '' OR isnull(srfgub) then return 
	
	  		SELECT "IMPRAT"."HSNO"  
		 		INTO :sHsno
		 		FROM "IMPRAT"  
				WHERE "IMPRAT"."HSNO" = :srfgub   ;
		
		if sqlca.sqlcode <> 0 then 
			f_message_chk(33,'[H.S No]') 
			this.SetItem(lRow, "etcnbr", sNull)
			RETURN  1
		end if	
	Case	"porgu" 
		this.SetItem(lRow, "flag2", '1')  //변경시 flag에 값을 넣어줌
End Choose

//==================================================================================


end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;IF this.GetColumnName() ="etcnbr" THEN
	open(w_hsno_popup)
	IF isnull(gs_Code) or gs_Code = ''	then  RETURN
	this.SetItem(row, "etcnbr", gs_code)
END IF	
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type p_delrow from w_inherite`p_delrow within w_pdm_01260
boolean visible = false
integer x = 960
integer y = 3032
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01260
boolean visible = false
integer x = 786
integer y = 3032
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01260
boolean visible = false
integer x = 1143
integer y = 3048
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01260
integer x = 3730
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;int  i, il_currow, il_rowcount
string s_gub, s_lms, s_large, s_mid, get_nm, ls_porgu

if dw_1.AcceptText() = -1 then return 

s_lms = dw_1.GetItemString(1,'lmsgub')
s_gub = dw_1.GetItemString(1,'sittyp')

if isnull(s_gub) or s_gub = "" then
	f_message_chk(30,'[품목구분]')
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
	
	dw_insert.setitem(il_currow, 'ittyp', s_gub )
	
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetColumn('itcls')
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
	
	dw_insert.setitem(il_currow, 'ittyp', s_gub )
   dw_insert.setitem(il_currow, 'itcls', s_large )
	
	//
	
   SELECT "ITNCT"."PDTGU","ITNCT"."PORGU"   
     INTO :get_nm , :ls_porgu
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :s_gub ) AND  
          ( "ITNCT"."ITCLS" = :s_large ) AND  
          ( "ITNCT"."LMSGU" = 'L' )   ;

   dw_insert.setitem(il_currow, 'pdtgu', get_nm )
	dw_insert.setitem(il_currow, 'porgu', ls_porgu )
  
	dw_insert.ScrollToRow(il_currow)
	dw_insert.SetColumn('mtcls')
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
	
   dw_insert.setitem(il_currow, 'ittyp', s_gub )
   dw_insert.setitem(il_currow, 'itcls', s_mid )
   dw_insert.setitem(il_currow, 'sabu', gs_sabu )
		
   SELECT "ITNCT"."PDTGU","ITNCT"."PORGU"
     INTO :get_nm, :ls_porgu
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :s_gub ) AND  
          ( "ITNCT"."ITCLS" = :s_large ) AND  
          ( "ITNCT"."LMSGU" = 'L' )   ;

   dw_insert.setitem(il_currow, 'pdtgu', get_nm )
	dw_insert.setitem(il_currow, 'porgu', ls_porgu )
   dw_insert.ScrollToRow(il_currow)
	dw_insert.SetColumn('stcls')
	dw_insert.SetFocus()
end if

end event

type p_exit from w_inherite`p_exit within w_pdm_01260
integer x = 4425
end type

type p_can from w_inherite`p_can within w_pdm_01260
integer x = 4251
end type

event p_can::clicked;call super::clicked;wf_modify('L')
dw_1.SetItem(1, "lmsgub", 'L')

wf_reset()

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdm_01260
boolean visible = false
integer x = 1317
integer y = 3048
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01260
integer x = 3557
end type

event p_inq::clicked;call super::clicked;string s_lms, s_gub, s_gub1, s_large, s_mid

if dw_1.AcceptText() = -1 then return 

s_lms = dw_1.GetItemString(1,'lmsgub')
s_gub = trim(dw_1.GetItemString(1,'sittyp'))

if isnull(s_gub) or s_gub = "" then
	f_message_chk(30,'[품목구분]')
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

type p_del from w_inherite`p_del within w_pdm_01260
integer x = 4078
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
s_itcls = dw_insert.GetItemString(dw_insert.getrow(),'itcls')

if f_msg_delete() = -1 then return

if s_lms = 'L' then 
	s_itcls = s_itcls + '%'
   SELECT COUNT(*)
     INTO :get_count  
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :s_gub ) AND  
          ( "ITNCT"."ITCLS" LIKE :s_itcls ) AND  
          ( "ITNCT"."LMSGU" <> 'L' )   ;

   IF get_count > 0 then 
		messagebox("삭제불가", "삭제하시려면 먼저 중분류 자료부터 삭제하세요!!")
	   return 
   END IF
elseif s_lms = 'M' then 	
   i_seq = dw_insert.GetItemNumber(dw_insert.getrow(),'seq')
	s_itcls = s_itcls + '%'
	
   if i_seq > 0 then	
		messagebox("삭제불가", "순번이 0 보다 크면 삭제할 수 없습니다!!")
	   return 
   END IF
   
	DELETE FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_gub ) AND  
         ( "ITNCT"."ITCLS" like :s_itcls ) AND  
         ( "ITNCT"."LMSGU" = 'S' )   ;
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

type p_mod from w_inherite`p_mod within w_pdm_01260
integer x = 3904
end type

event p_mod::clicked;call super::clicked;long i
string s_lms, s_itcls, s_ittyp, s_pdtgu, ls_porgu

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

//------------------------------------------------------------------------

Choose Case s_lms
	Case	"L" 
		FOR i=1 TO dw_insert.rowcount()
			IF  ( s_ittyp = '1' or s_ittyp = '2' OR S_ITTYP = '7') then        //완제품, 반제품일 경우 , 상품추가
	 			s_itcls = dw_insert.getitemstring(i, 'itcls')   + '%'
      			if dw_insert.getitemstring(i, 'flag') = '1' then
			 		s_pdtgu = dw_insert.getitemstring(i, 'pdtgu')   
			 
         	 		UPDATE "ITNCT"  
			    		SET "PDTGU" = :s_pdtgu  
			    		WHERE ( "ITNCT"."ITTYP"      = :s_ittyp ) AND  
					   		  ( "ITNCT"."ITCLS" LIKE :s_itcls ) AND  
					      	  ( "ITNCT"."LMSGU" <> 'L' )   ;
       			end if	
			END IF
	  // --------- 사업장구분을 하위(중분류,소분류)에도 동일한 사업장 구분 으로 입력.
      		If dw_insert.getitemstring(i, 'flag2') = '1' then
    	    		 	ls_porgu = dw_insert.getitemstring(i, 'porgu')   
          				UPDATE "ITNCT"  
			    			SET "PORGU" = :ls_porgu
			  			WHERE 	( "ITNCT"."ITTYP"     = :s_ittyp ) AND  
							  		( "ITNCT"."ITCLS" LIKE :s_itcls ) AND  
  					  		  		(( "ITNCT"."LMSGU" = 'M' ) or ( "ITNCT"."LMSGU" = 'S' ))   ;
			End If
	  
   		NEXT
	Case	"M" 
		FOR i=1 TO dw_insert.rowcount()
	  	// --------- 사업장구분을 하위(중분류,소분류)에도 동일한 사업장 구분 으로 입력.
      		If dw_insert.getitemstring(i, 'flag2') = '1' then
         			s_itcls = dw_insert.getitemstring(i, 'ltcls') + dw_insert.getitemstring(i, 'mtcls') + '%'
    	     			ls_porgu = dw_insert.getitemstring(i, 'porgu')   
          			UPDATE "ITNCT"  
			    		SET "PORGU" = :ls_porgu
			  		WHERE 	( "ITNCT"."ITTYP" = :s_ittyp ) AND  
						  		( "ITNCT"."ITCLS" LIKE :s_itcls ) AND  
  						  		( "ITNCT"."LMSGU" = 'S' )   ;
			End If
	  	//----
         		s_itcls = dw_insert.getitemstring(i, 'ltcls') + dw_insert.getitemstring(i, 'mtcls')
	    		dw_insert.setitem(i, 'itcls', s_itcls)
   		NEXT
	Case	"S" 
		FOR i=1 TO dw_insert.rowcount()
         		s_itcls = dw_insert.getitemstring(i, 'ltcls') + dw_insert.getitemstring(i, 'stcls')
	    		dw_insert.setitem(i, 'itcls', s_itcls)
   		NEXT
End Choose

//------------------------------------------------------------------------

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

type cb_exit from w_inherite`cb_exit within w_pdm_01260
integer x = 3296
integer y = 3084
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01260
integer x = 2222
integer y = 3076
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01260
integer x = 1874
integer y = 3072
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01260
integer x = 2583
integer y = 3076
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01260
integer x = 1518
integer y = 3072
end type

type cb_print from w_inherite`cb_print within w_pdm_01260
integer x = 1783
integer y = 2664
end type

type st_1 from w_inherite`st_1 within w_pdm_01260
end type

type cb_can from w_inherite`cb_can within w_pdm_01260
integer x = 2944
integer y = 3076
end type

type cb_search from w_inherite`cb_search within w_pdm_01260
integer x = 2139
integer y = 2660
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01260
integer x = 41
integer y = 2804
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01260
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01260
end type

type dw_1 from datawindow within w_pdm_01260
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 133
integer y = 48
integer width = 3337
integer height = 148
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdm_01260_a"
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
	IF	Isnull(s_pumgu)  or  trim(s_pumgu) = ''	Then
		this.SetItem(1,"large",snull)
		this.SetItem(1,"large_nm",snull)
		this.SetItem(1,"mid",snull)
		this.SetItem(1,"mid_nm",snull)
		wf_reset()
		RETURN
   END IF
	sget_name = f_get_reffer('05',s_pumgu)
	IF IsNull(sget_name) THEN
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,"sittyp",snull)
		this.SetItem(1,"large",snull)
		this.SetItem(1,"large_nm",snull)
		this.SetItem(1,"mid",snull)
		this.SetItem(1,"mid_nm",snull)
		this.Setcolumn("sittyp")
		this.SetFocus()
		wf_reset()
		Return 1	
   ELSE
		this.SetItem(1,"large",snull)
		this.SetItem(1,"large_nm",snull)
		this.SetItem(1,"mid",snull)
		this.SetItem(1,"mid_nm",snull)
   	sgub = this.GetItemString(1, 'lmsgub') 
		if sgub = 'L' then 
         p_inq.TriggerEvent(Clicked!)
      else
   		wf_reset()
		end if	
   END IF
// 대중소 분류 선택
ELSEIF this.GetColumnName() ="lmsgub" THEN
	sgub = this.GetText()
   wf_modify(sgub)
	wf_reset()
ELSEIF this.GetColumnName() ="large" THEN
	s_large = this.GetText()
	IF s_large = "" or isnull(s_large) then
		this.SetItem(1,"large_nm",snull)
		wf_reset()
   	return  
	END IF
	s_pumgu = this.getitemstring(1, 'sittyp')
	if s_pumgu = "" or isnull(s_pumgu) then 
		messagebox("확인", "품목구분을 먼저 입력하세요!!") 
		this.SetItem(1,"large",snull)
		this.setcolumn("sittyp")
		this.setfocus()
		wf_reset()
	   return 1
	end if

   SELECT "ITNCT"."TITNM"  
     INTO :get_nm   
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :s_pumgu ) AND  
          ( "ITNCT"."ITCLS" = :s_large )   ;

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
   
	IF s_mid = "" or isnull(s_mid) then
		this.SetItem(1,"mid_nm",snull)
		wf_reset()
   	return  
	END IF
	
	s_pumgu = this.getitemstring(1, 'sittyp')
	
	if s_pumgu = "" or isnull(s_pumgu) then 
		this.SetItem(1,"mid",snull)
		messagebox("확인", "품목구분을 먼저 입력하세요!!") 
		this.setcolumn("sittyp")
		this.setfocus()
		wf_reset()
	   return 1
	end if

   SELECT "ITNCT"."TITNM"  
     INTO :get_nm   
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :s_pumgu ) AND  
          ( "ITNCT"."ITCLS" = :s_mid )   ;

	IF SQLCA.SQLCODE <> 0 then 
		this.triggerevent(rbuttondown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.setitem(1, "mid", snull)
			this.setitem(1, "mid_nm", snull)
      END IF
      RETURN 1
   ELSE
		s_large = left(s_mid, 2)
				
		SELECT "ITNCT"."TITNM"  
		  INTO :get_nm2   
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITTYP" = :s_pumgu ) AND  
				 ( "ITNCT"."ITCLS" = :s_large )   ;
      
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
	
	open(w_itnct_l_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN
	
	this.SetItem(1, "sittyp", gs_gubun)
	this.SetItem(1, "large", gs_Code)
	this.SetItem(1, "large_nm", gs_Codename)
   p_inq.TriggerEvent(Clicked!)
   return 1 
ELSEIF this.GetColumnName() ="mid" THEN

	gs_gubun = this.getitemstring(1, 'sittyp')
	
	open(w_itnct_m_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN

	string s_large, get_nm
	
	s_large = left(gs_code, 2)
	
   SELECT "ITNCT"."TITNM"  
     INTO :get_nm  
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :gs_gubun ) AND  
          ( "ITNCT"."ITCLS" = :s_large )   ; 
		
   if sqlca.sqlcode <> 0 then 
		f_message_chk(52, "")
		this.SetItem(1, "sittyp", snull)
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

type rr_1 from roundrectangle within w_pdm_01260
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 32
integer width = 3465
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01260
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 228
integer width = 4535
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_pdt_01000.srw
$PBExportComments$** 년간 생산계획 조정
forward
global type w_pdt_01000 from w_inherite
end type
type dw_1 from datawindow within w_pdt_01000
end type
type dw_hidden from datawindow within w_pdt_01000
end type
type st_2 from statictext within w_pdt_01000
end type
type dw_capa from datawindow within w_pdt_01000
end type
type rr_1 from roundrectangle within w_pdt_01000
end type
end forward

global type w_pdt_01000 from w_inherite
integer height = 2396
string title = "년간 생산계획 조정"
dw_1 dw_1
dw_hidden dw_hidden
st_2 st_2
dw_capa dw_capa
rr_1 rr_1
end type
global w_pdt_01000 w_pdt_01000

type variables
string ls_text, is_pspec, is_jijil
Long   ilby
end variables

forward prototypes
public subroutine wf_reset ()
public subroutine wf_modify (string s_gub)
public function integer wf_required_chk (integer i)
end prototypes

public subroutine wf_reset ();string s_nextyear
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)

s_nextyear = string(long(left(f_today(), 4)) + 1)

dw_1.setitem(1, 'syear', s_nextyear)

SELECT MAX("YEAPLN"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( substr("YEAPLN"."YEAYYMM", 1, 4) = :s_nextyear )   ;

dw_1.setitem(1, "jjcha", get_yeacha)
dw_1.SetFocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

public subroutine wf_modify (string s_gub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull

setnull(snull)

IF s_gub = '0' THEN
   dw_insert.DataObject ="d_pdt_01000_2" 
   dw_insert.SetTransObject(SQLCA)
ELSE
   dw_insert.DataObject ="d_pdt_01000_1" 
   dw_insert.SetTransObject(SQLCA)
END IF

end subroutine

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	


Return 1
end function

on w_pdt_01000.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_hidden=create dw_hidden
this.st_2=create st_2
this.dw_capa=create dw_capa
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_hidden
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_capa
this.Control[iCurrent+5]=this.rr_1
end on

on w_pdt_01000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_hidden)
destroy(this.st_2)
destroy(this.dw_capa)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_hidden.SetTransObject(sqlca)
dw_capa.SetTransObject(sqlca)
dw_1.insertrow(0)

string s_nextyear
int    get_yeacha

s_nextyear = string(long(left(f_today(), 4)) + 1)

dw_1.setitem(1, 'syear', s_nextyear)

SELECT MAX("YEAPLN"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( "YEAPLN"."YEAYYMM" like :s_nextyear||'%' )   ;
		 
f_mod_saupj(dw_1, 'porgu')
f_child_saupj(dw_1, 'steam', gs_saupj)

// M환산기준
select to_number(dataname) INTO :ilby from syscnfg where sysgu = 'Y' and serial = 2 and lineno = :gs_saupj;
If IsNull(ilby) Or ilby <= 0 Then ilby = 500000

dw_1.setitem(1, "jjcha", get_yeacha)
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

type dw_insert from w_inherite`dw_insert within w_pdt_01000
integer x = 59
integer y = 404
integer width = 4512
integer height = 1272
integer taborder = 30
string dataobject = "d_pdt_01000_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;string  snull, sitnbr, sitdsc, sispec, syear, syear2, get_itnbr, steam, sjijil, sispeccode
integer ireturn, get_count, iseq
long    lrow, lreturnrow
double  dItemPrice

dw_1.accepttext()

setnull(snull)

lrow    	= this.getrow()
syear   	= dw_1.getitemstring(1, 'syear')
steam   	= dw_1.getitemstring(1, 'steam')
iseq    	= dw_1.getitemnumber(1, 'jjcha')
syear2  	= syear + '%'

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())

   if sitnbr = "" or isnull(sitnbr) then
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)
		this.SetItem(lRow, "ypdprc",0)
		return 
   end if	

   //자체 데이타 원도우에서 같은 품번을 체크
	lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[품번]') 
		this.setitem(lrow, "itnbr", snull)	
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)
		this.SetItem(lRow, "ypdprc",0)
		RETURN  1
	END IF
  //저장된 품번인지 체크
	SELECT COUNT("YEAPLN"."ITNBR")  
     INTO :get_count
     FROM "YEAPLN"  
    WHERE ( "YEAPLN"."SABU" = :gs_sabu )     AND ( "YEAPLN"."ITNBR"  = :sitnbr ) AND  
          ( "YEAPLN"."YEAYYMM" like :syear2 ) AND ( "YEAPLN"."YEACHA" = :iseq ) ;  

   if isnull(get_count) or get_count = 0 then 
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패
		if ireturn = 1 then ireturn = 0 else ireturn = 1
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)
      IF ireturn = 0 then
			//생산팀이 등록되였는지 체크
 		   SELECT "ITEMAS"."ITNBR"  , "ITEMAS"."PORGU"  
			  INTO :get_itnbr  , :sispeccode
			  FROM "ITEMAS", "ITNCT"  , 
			 WHERE 	( "ITEMAS"."ITTYP" 	= "ITNCT"."ITTYP" ) and  
					 	( "ITEMAS"."ITCLS" 	= "ITNCT"."ITCLS" ) and  
					 	( "ITEMAS"."ITNBR" 	= :sitnbr ) AND  
					 	( "ITNCT"."PDTGU" 	= :steam )    ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('확인', ls_text ) 
				this.setitem(lrow, "itnbr", snull)	
				this.setitem(lrow, "itdsc", snull)	
				this.setitem(lrow, "ispec", snull)
				this.SetItem(lRow, "ypdprc",0)
				RETURN 1
			END IF
			dItemPrice = sqlca.Fun_Erp100000012(syear+'0101',sItnbr,'.' ) 
			this.SetItem(lRow,"porgu",	sispeccode)
			this.SetItem(lRow,"ypdprc",	dItemPrice)
			this.Setfocus()
      END IF
		RETURN ireturn
	else
		f_message_chk(37,'[품번]') 
		this.setitem(lrow, "itnbr", snull)	
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)
		this.SetItem(lRow, "ypdprc",0)
		RETURN 1
	end if	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
   if sitdsc = "" or isnull(sitdsc) then
		this.setitem(lrow, "itnbr", snull)	
		this.setitem(lrow, "ispec", snull)
		this.SetItem(lRow, "ypdprc",0)
		return 
   end if	
	ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패
	if ireturn = 1 then ireturn = 0 else ireturn = 1
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   if ireturn = 0 then 
		//자체 데이타 원도우에서 같은 품번을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount()) 
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
   		f_message_chk(37,'[품번]') 
			this.setitem(lrow, "itdsc", snull)	
   		this.setitem(lrow, "itnbr", snull)	
			this.setitem(lrow, "ispec", snull)
			this.SetItem(lRow, "ypdprc",0)
			RETURN  1
		END IF
		
		SELECT COUNT("YEAPLN"."ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN"  
		 WHERE ( "YEAPLN"."SABU" = :gs_sabu )     AND ( "YEAPLN"."ITNBR"  = :sitnbr ) AND  
				 ( "YEAPLN"."YEAYYMM" like :syear2 ) AND ( "YEAPLN"."YEACHA" = :iseq ) ;  
	
		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			this.setitem(lrow, "itnbr", snull)	
			this.setitem(lrow, "itdsc", snull)	
			this.setitem(lrow, "ispec", snull)
			this.SetItem(lRow, "ypdprc",0)
			RETURN 1
      else
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('확인', ls_text ) 
				this.setitem(lrow, "itnbr", snull)	
				this.setitem(lrow, "itdsc", snull)	
				this.setitem(lrow, "ispec", snull)
				this.SetItem(lRow, "ypdprc",0)
				RETURN 1
			END IF

			dItemPrice = sqlca.Fun_Erp100000012(syear+'0101',sItnbr, '.') 
			this.SetItem(lRow,"ypdprc",	dItemPrice)
			this.Setfocus()
      end if		
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
   if sispec = "" or isnull(sispec) then
		this.setitem(lrow, "itnbr", snull)	
		this.setitem(lrow, "itdsc", snull)	
		this.SetItem(lRow, "ypdprc",0)
		return 
   end if	
	
	ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	//1이면 성공, 0이 실패
	if ireturn = 1 then ireturn = 0 else ireturn = 1
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)

   if ireturn = 0 then 
		//자체 데이타 원도우에서 같은 품번을 체크
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
 			f_message_chk(37,'[품번]') 
    		this.setitem(lrow, "itnbr", snull)	
	   	this.setitem(lrow, "itdsc", snull)	
			this.setitem(lrow, "ispec", snull)
			this.SetItem(lRow, "ypdprc",0)
			RETURN  1
		END IF
		
		SELECT COUNT("YEAPLN"."ITNBR")  
		  INTO :get_count
		  FROM "YEAPLN"  
		 WHERE ( "YEAPLN"."SABU" = :gs_sabu )    AND ( "YEAPLN"."ITNBR"  = :sitnbr ) AND  
				 ( "YEAPLN"."YEAYYMM" like :syear2 ) AND ( "YEAPLN"."YEACHA" = :iseq ) ;  
	
		if get_count > 0 then 
			f_message_chk(37,'[품번]') 
			this.setitem(lrow, "itnbr", snull)	
			this.setitem(lrow, "itdsc", snull)	
			this.setitem(lrow, "ispec", snull)
			this.SetItem(lRow, "ypdprc",0)
			RETURN 1
      else
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('확인', ls_text ) 
				this.setitem(lrow, "itnbr", snull)	
				this.setitem(lrow, "itdsc", snull)	
				this.setitem(lrow, "ispec", snull)
				this.SetItem(lRow, "ypdprc",0)
				RETURN 1
			END IF

			dItemPrice = sqlca.Fun_Erp100000012(syear+'0101',sItnbr, '.') 
			this.SetItem(lRow,"ypdprc",	dItemPrice)
			this.Setfocus()
      end if		
   end if		
	RETURN ireturn
END IF
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

type p_delrow from w_inherite`p_delrow within w_pdt_01000
integer y = 5000
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_pdt_01000
integer y = 5000
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_pdt_01000
boolean visible = false
integer x = 3191
integer taborder = 150
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\판매계획_up.gif"
end type

event p_search::clicked;call super::clicked;string s_year
int    i_seq

if dw_1.AcceptText() = -1 then return 
s_year = trim(dw_1.GetItemString(1,'syear'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if

gs_code = s_year
gs_codename = string(i_seq) 
		
Open(w_pdt_01001)


end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\판매계획_up.gif"
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\판매계획_dn.gif"
end event

type p_ins from w_inherite`p_ins within w_pdt_01000
integer x = 3712
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;string s_team, s_year
Int    i_seq
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_year = trim(dw_1.GetItemString(1,'syear'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	
if isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if	
if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정차수]')
	dw_1.Setcolumn('jjcha')
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

dw_insert.setitem(il_currow, 'sabu', gs_sabu )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_1.enabled = false
p_search.enabled = false
p_print.enabled = false
p_search.PictureName = "c:\erpman\image\판매계획_d.gif"
p_print.PictureName = "c:\erpman\image\계획조정_d.gif"
ib_any_typing =True

end event

type p_exit from w_inherite`p_exit within w_pdt_01000
integer x = 4407
integer taborder = 130
end type

type p_can from w_inherite`p_can within w_pdt_01000
integer x = 4233
integer taborder = 110
end type

event p_can::clicked;call super::clicked;wf_reset()

dw_insert.DataObject ="d_pdt_01000_1" 
dw_insert.SetTransObject(SQLCA)

dw_1.enabled = true
p_search.enabled = true
p_print.enabled = true
p_search.PictureName = "c:\erpman\image\판매계획_up.gif"
p_print.PictureName = "c:\erpman\image\계획조정_up.gif"
p_ins.enabled = false
p_del.enabled = false
p_ins.PictureName = "c:\erpman\image\추가_d.gif"
p_del.PictureName = "c:\erpman\image\삭제_d.gif"

ib_any_typing = FALSE

dw_1.setfocus()

end event

type p_print from w_inherite`p_print within w_pdt_01000
boolean visible = false
integer x = 3365
integer taborder = 170
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\계획조정_up.gif"
end type

event p_print::clicked;call super::clicked;string s_year

if dw_1.AcceptText() = -1 then return 
s_year = trim(dw_1.GetItemString(1,'syear'))

gs_code = s_year
		
Open(w_pdt_01002)


end event

event p_print::ue_lbuttonup;pictureName = "C:\erpman\image\계획조정_up.gif"
end event

event p_print::ue_lbuttondown;pictureName = "C:\erpman\image\계획조정_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_pdt_01000
integer x = 3538
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_year, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr , ls_porgu
String sPangbn
Int    i_seq

if dw_1.AcceptText() = -1 then return 

s_gub  	= dw_1.GetItemString(1,'sgub')
s_team 	= dw_1.GetItemString(1,'steam')
s_year 	= trim(dw_1.GetItemString(1,'syear'))
i_seq  	= dw_1.GetItemNumber(1,'jjcha')
ls_porgu = dw_1.GetItemString(1,'porgu')
sPangbn 	= Trim(dw_1.GetItemString(1,'pangbn'))
If IsNull(sPangbn) Then sPangbn = ''

if	isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	
if	isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if	
if	isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정차수]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if

//if isnull(sPangbn) or sPangbn = "" then
//	f_message_chk(30,'[계획구분]')
//	dw_1.Setcolumn('pangbn')
//	dw_1.SetFocus()
//	return
//end if

s_ittyp   = dw_1.GetItemString(1,'sittyp')
if isnull(s_ittyp) or s_ittyp = "" then
	f_message_chk(30,'[품목구분]')
	dw_1.Setcolumn('sittyp')
	dw_1.SetFocus()
	return
end if	
	
// [ 구분   0 : 품목분류 , 1: 품번 ]
If 	s_gub = '0' then //품목분류로 조회

  	s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
	if 	isnull(s_fritcls) or s_fritcls = "" then
      	s_fritcls = '.'
   	end if	
   	s_toitcls = trim(dw_1.GetItemString(1,'to_itcls'))
	if 	isnull(s_toitcls) or s_toitcls = "" then
      	s_toitcls = 'zzzzzzz'
   	end if	
   	if 	s_fritcls > s_toitcls then 
		f_message_chk(34,'[품목분류]')
		dw_1.Setcolumn('fr_itcls')
		dw_1.SetFocus()
		return
	end if	
	if dw_insert.Retrieve(gs_sabu, ls_porgu, s_team,s_year,i_seq,s_ittyp,s_fritcls,s_toitcls) <= 0 then 
		f_message_chk(50,'')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		p_ins.enabled = true
		p_del.enabled = true
		p_ins.PictureName = "c:\erpman\image\추가_up.gif"
      	p_del.PictureName = "c:\erpman\image\삭제_up.gif"
      	return
	end if	
Else   //품번으로 조회
   s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
	if	isnull(s_fritnbr) or s_fritnbr = "" then
      	s_fritnbr = '.'
   	end if	
   s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))
	if	isnull(s_toitnbr) or s_toitnbr = "" then
      s_toitnbr = 'zzzzzzzzzzzzzzz'
  	end if	
   	if 	s_fritnbr > s_toitnbr then 
		f_message_chk(34,'[품번]')
		dw_1.Setcolumn('fr_itnbr')
		dw_1.SetFocus()
		return
	end if
	
	if dw_insert.Retrieve(gs_sabu, ls_porgu, s_team,s_year,i_seq, sPangbn+'%', ilby) <= 0 then 
		f_message_chk(50,'')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		p_ins.enabled = true
		p_del.enabled = true
		p_ins.PictureName = "c:\erpman\image\추가_up.gif"
		p_del.PictureName = "c:\erpman\image\삭제_up.gif"
		return
	end if
	
	// Capa 조회
	dw_capa.Retrieve(s_team, s_year, s_ittyp)
End if	

p_ins.enabled = true
p_del.enabled = true
p_ins.PictureName = "c:\erpman\image\추가_up.gif"
p_del.PictureName = "c:\erpman\image\삭제_up.gif"
//dw_1.enabled = false
p_search.enabled = false
p_print.enabled = false
p_search.PictureName = "c:\erpman\image\판매계획_d.gif"
p_print.PictureName = "c:\erpman\image\계획조정_d.gif"
ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_pdt_01000
integer x = 4059
integer taborder = 100
end type

event p_del::clicked;call super::clicked;string s_itnbr, s_year, s_yeagubn
int    i_seq
long   lrow

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

lrow = dw_insert.getrow()
if lrow <= 0 then return 

if f_msg_delete() = -1 then return

s_year  = dw_1.GetItemString(1,'syear')
s_year  = s_year + '%'
i_seq   = dw_1.GetItemNumber(1,'jjcha')
s_itnbr = dw_insert.GetItemString(lrow, 'itnbr')

dw_insert.SetRedraw(FALSE)
dw_insert.DeleteRow(lrow)

DELETE FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( "YEAPLN"."ITNBR" = :s_itnbr ) AND  
		 ( "YEAPLN"."YEAYYMM" like :s_year ) AND  
		 ( "YEAPLN"."YEACHA" = :i_seq )   ;


if sqlca.sqlcode = 0 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_mod from w_inherite`p_mod within w_pdt_01000
integer x = 3886
integer taborder = 80
end type

event p_mod::clicked;call super::clicked;Long k, i, iseq
dec{2} d_yprc, d_amt
dec{3} d_qty, d_flag
string s_flag, sitnbr, syear, s_column, sysdate, s_yymm, s_gubun
String sMonth[12] = {'01','02','03','04','05','06','07','08','09','10','11','12'}

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR k = 1 TO dw_insert.RowCount()
	IF wf_required_chk(k) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "저장 중.........."
syear  = dw_1.getitemstring(1, 'syear') 	
iseq   = dw_1.getitemnumber(1, 'jjcha')
FOR k = 1 TO dw_insert.RowCount()
   sitnbr = dw_insert.getitemstring(k, 'itnbr')
   d_yprc = dw_insert.getitemnumber(k, 'ypdprc')
	   

		FOR i = 1 TO 12
         s_column = "qty"   + sMonth[i]
         s_flag   = "sflag" + sMonth[i]			
         s_yymm = ''
			s_yymm = syear + sMonth[i]
         d_qty  = dw_insert.getitemnumber(k, s_column)
         d_flag = dw_insert.getitemnumber(k, s_flag)			

			IF isnull(d_qty) then d_qty = 0
			IF isnull(d_yprc) then d_yprc = 0
			
			d_amt = d_qty * d_yprc
			if d_flag > 0 then
				UPDATE "YEAPLN"  
					SET "YPDQTY" = :d_qty, "YPDAMT" = :d_amt, "YPGUB" = '1'  
				 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND ( "YEAPLN"."ITNBR" = :sitnbr ) AND  
						 ( "YEAPLN"."YEAYYMM" = :s_yymm ) AND ( "YEAPLN"."YEACHA" = :iseq ) AND  
						 ( "YEAPLN"."YEAGU" = 'A' )   ;
			Else
					sysdate = f_today()
					
				  INSERT INTO "YEAPLN"  
							( "SABU",    "ITNBR",  "YEAYYMM",   "YEACHA",    "YEAGUBN",  "YEAGU",
							  "YPDQTY",  "YPDPRC", "YPDAMT",    "CURR_DATE", "YPGUB" )  
				  VALUES ( :gs_sabu, :sitnbr,  :s_yymm,      :iseq,      '0',    'A',     
							  :d_qty,    :d_yprc,  :d_amt,       :sysdate,    '1' )  ;
			End if

        if sqlca.sqlcode <> 0 then			
	   	  rollback ;
			  messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
			  return 
	     end if		
			
		NEXT 

NEXT

if sqlca.sqlcode = 0 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_01000
integer x = 4229
integer y = 5000
integer taborder = 180
end type

type cb_mod from w_inherite`cb_mod within w_pdt_01000
integer x = 3817
integer y = 5000
integer taborder = 120
end type

type cb_ins from w_inherite`cb_ins within w_pdt_01000
integer x = 3776
integer y = 5000
integer taborder = 90
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_01000
integer x = 3762
integer y = 5000
integer taborder = 140
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_01000
integer x = 3401
integer y = 5000
end type

type cb_print from w_inherite`cb_print within w_pdt_01000
integer x = 4123
integer y = 5000
integer width = 407
string text = "계획조정"
end type

type st_1 from w_inherite`st_1 within w_pdt_01000
end type

type cb_can from w_inherite`cb_can within w_pdt_01000
integer x = 4201
integer y = 5000
integer taborder = 160
end type

type cb_search from w_inherite`cb_search within w_pdt_01000
integer x = 2999
integer y = 5000
integer width = 407
integer taborder = 60
string text = "판매계획"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_01000
integer x = 14
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_01000
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_01000
end type

type dw_1 from datawindow within w_pdt_01000
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 4
integer width = 2203
integer height = 376
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_01000_a"
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

event itemchanged;string snull, syear, s_name, s_itt, s_nextyear, s_gub, steam, steamnm, stitnm, stextnm
int    iseq, inull, get_yeacha, i

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="porgu" THEN
	s_gub = trim(this.GetText())
	
	//생산팀
	f_child_saupj(this, 'steam', s_gub)
ELSEIF this.GetColumnName() ="steam" THEN
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
ELSEIF this.GetColumnName() ="syear" THEN
	syear = trim(this.GetText())
	
	if syear = "" or isnull(syear) then
  		this.setitem(1, 'jjcha', inull)
		return 
	end if	

	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )   ;
	
	this.setitem(1, 'jjcha', get_yeacha)

ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq = integer(this.GetText())
   syear = this.getitemstring(1, 'syear')
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syear = "" or isnull(syear) then 
		messagebox("확인", "계획년도를 먼저 입력 하십시요!!")
		this.setcolumn('syear')
		this.setfocus()
		return 1
	end if		
		
	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )  ;
			 
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("확인", syear + "년에 최종 조정차수가 없으니 " &
			                   + "1차만 입력가능합니다!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	else
		if iseq > get_yeacha + 1 then
   		messagebox("확인", syear + "년에 최종 조정차수가 " + &
			                   string(get_yeacha) + "차 입니다!!")
			this.setitem(1, 'jjcha', get_yeacha)
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
   ELSEIF s_itt = '1' or s_itt = '2' or s_itt = '6' THEN //1완제품, 2반제품, 6상품  
   ELSE 	
		f_message_chk(61,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   END IF	
ELSEIF this.GetColumnName() = 'sgub' THEN
	s_gub = this.gettext()
    	
	wf_modify(s_gub)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string  sname
str_itnct lstr_sitnct

setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   	gs_code = this.GetText()
     	setNull(gs_gubun)
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
     	setNull(gs_gubun)
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
		    lstr_sitnct.s_ittyp = '6' THEN //1완제품, 2반제품, 6상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fr_itcls", lstr_sitnct.s_sumgub)
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
		    lstr_sitnct.s_ittyp = '6' THEN //1완제품, 2반제품, 6상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"to_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
end if	

end event

event losefocus;THIS.accepttext()
end event

type dw_hidden from datawindow within w_pdt_01000
boolean visible = false
integer x = 1047
integer y = 2320
integer width = 494
integer height = 360
boolean bringtotop = true
string dataobject = "d_pdt_01000_9"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_pdt_01000
integer x = 69
integer y = 1704
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "* 생산능력"
boolean focusrectangle = false
end type

type dw_capa from datawindow within w_pdt_01000
integer x = 59
integer y = 1764
integer width = 4512
integer height = 552
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_01000_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdt_01000
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 396
integer width = 4544
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type


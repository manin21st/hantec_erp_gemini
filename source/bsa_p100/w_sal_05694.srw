$PBExportHeader$w_sal_05694.srw
$PBExportComments$ 전년대비 판매실적
forward
global type w_sal_05694 from w_standard_print
end type
type tab_1 from tab within w_sal_05694
end type
type tabpage_1 from userobject within tab_1
end type
type dw_list_tab1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_list_tab1 dw_list_tab1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_list_tab2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_list_tab2 dw_list_tab2
end type
type tabpage_4 from userobject within tab_1
end type
type dw_list_tab4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_list_tab4 dw_list_tab4
end type
type tabpage_3 from userobject within tab_1
end type
type dw_list_tab3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_list_tab3 dw_list_tab3
end type
type tab_1 from tab within w_sal_05694
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
end forward

global type w_sal_05694 from w_standard_print
string title = "전년대비 판매실적"
tab_1 tab_1
end type
global w_sal_05694 w_sal_05694

type variables
datawindow dw_select
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear[5]            // 5개년으로 제한
string   frmm,tomm,steam,pdtgu,itcls,itclsnm ,ls_gubun
string   tx_syear,tx_month,tx_steam,tx_pdtgu,tx_itcls,stemp, sArea, tx_sarea
int      rtn,ix,ii

////////////////////////////////////////////// 검색조건 check
If dw_ip.accepttext() <>  1 Then Return -1

ls_gubun = dw_ip.getitemstring(1,'gubun')

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;
		
if ls_gubun = '1' then

		syear[1] = trim(dw_ip.getitemstring(1, 'sdate'))
		frmm     = trim(dw_ip.getitemstring(1, 'sfrmm'))
		tomm     = trim(dw_ip.getitemstring(1, 'stomm'))
		steam    = trim(dw_ip.getitemstring(1, 'steam'))
		pdtgu    = trim(dw_ip.getitemstring(1, 'pdtgu'))
		itcls    = trim(dw_ip.getitemstring(1, 'itcls'))
		stemp    = trim(dw_ip.getitemstring(1, 'sdatecom'))
		
		If IsNull(steam)  Then steam = ''
		If IsNull(pdtgu)  Then pdtgu = ''
		If IsNull(itcls)  Then itcls = ''
		If IsNull(stemp)  Then stemp = ''
		If IsNull(frmm)  Then frmm = ''
		If IsNull(tomm)  Then tomm = ''
		
		For ix = 2 To 5
			ii = Pos(stemp,',')
			If Len(stemp) = 0 Then Exit
			
			If ii > 0 Then 
				syear[ix] = Left(stemp,ii - 1 )
				stemp = Mid(stemp,ii+1)
			Else		
				ix = 5		
				syear[ix] = stemp
			End If	
		
			IF	f_datechk(syear[ix]+'0101') = -1 then
				f_message_chk(42,"비교년도 : YYYY"+syear[ix])
				dw_ip.setfocus()
				REturn -1
			END IF
		Next
		
		IF	f_datechk(syear[1]+'0101') = -1 then
			MessageBox("확인","기준년도를 확인하세요!")
			dw_ip.setfocus()
			Return -1
		END IF
		
		IF	frmm = ''  then
			f_message_chk(1400,'판매월')      //필수입력항목
			dw_ip.setfocus()
			Return -1
		END IF
		
		IF	tomm = ''  then
			f_message_chk(1400,'판매월')      //필수입력항목
			dw_ip.setfocus()
			Return -1
		END IF
		
		////////////////////////////////// dw 선택및 트랜젝션 연결
		Choose Case tab_1.SelectedTab
			Case 1
				dw_select = tab_1.tabpage_1.dw_list_tab1
			   dw_print.dataObject="d_sal_05694_p"
		   Case 2
				dw_select = tab_1.tabpage_2.dw_list_tab2
			   dw_print.dataObject="d_sal_05695_p" 
		   Case 3
				dw_select = tab_1.tabpage_4.dw_list_tab4
			   dw_print.dataObject="d_sal_056951_p" 
		   Case 4
				dw_select = tab_1.tabpage_3.dw_list_tab3	
		      dw_print.dataObject="d_sal_05696_p"
      End Choose		
		dw_select.SetTransObject(sqlca)
		dw_print.SetTransObject(sqlca)
		//////////////////////////////////////////////////////////////
		dw_print.SetRedraw(False)

		Choose Case tab_1.SelectedTab
			Case 1
				rtn = dw_print.retrieve(gs_sabu,syear[1],syear[2],syear[3],syear[4],syear[5],&
												 frmm,tomm,steam+'%',pdtgu+'%',ls_silgu)
			Case 2
				rtn = dw_print.retrieve(gs_sabu,syear[1],syear[2],syear[3],syear[4],syear[5],&
												 frmm,tomm,steam+'%',pdtgu+'%',itcls+'%',ls_silgu)
			Case 3
				rtn = dw_print.retrieve(gs_sabu,syear[1],syear[2],syear[3],syear[4],syear[5],&
												 frmm,tomm,steam+'%',pdtgu+'%',itcls+'%',ls_silgu)
			Case 4		
				rtn = dw_print.retrieve(gs_sabu,syear[1],syear[2],syear[3],syear[4],syear[5],&
												 frmm,tomm,steam+'%',pdtgu+'%',itcls+'%',ls_silgu)
		End Choose		
		
		if rtn < 1	then
			f_message_chk(50,"")
			dw_ip.setfocus()
			dw_print.SetRedraw(True)
			return -1
		end if
		
		 dw_print.sharedata(dw_list)
		// title 년월 설정
		tx_steam = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steam) ', 1)"))
		tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
		tx_itcls  = trim(dw_ip.getitemstring(1, 'itclsnm'))
		
		If tx_steam = '' Then tx_steam = '전체'
		If tx_pdtgu = '' Then tx_pdtgu = '전체'
		If IsNull(tx_itcls) Or tx_itcls = '' Then tx_itcls = '전체'
		
		dw_select.Object.tx_syear.text = syear[1] + '년도'
		dw_select.Object.tx_month.text = frmm + '월 - '  + tomm + '월'
		dw_select.Object.tx_steamcd.text = tx_steam
		dw_select.Object.tx_pdtgu.text = tx_pdtgu
		dw_select.Object.tx_itcls.text = tx_itcls
		
else
	   syear[1] = trim(dw_ip.getitemstring(1, 'sdate'))
		frmm     = trim(dw_ip.getitemstring(1, 'sfrmm'))
		tomm     = trim(dw_ip.getitemstring(1, 'stomm'))
		steam    = trim(dw_ip.getitemstring(1, 'steam'))
		sArea    = trim(dw_ip.getitemstring(1, 'sarea'))
		pdtgu    = trim(dw_ip.getitemstring(1, 'pdtgu'))
		itcls    = trim(dw_ip.getitemstring(1, 'itcls'))
		stemp    = trim(dw_ip.getitemstring(1, 'sdatecom'))
		
		If IsNull(steam)  Then steam = ''
		If IsNull(sarea)  Then sarea = ''
		If IsNull(pdtgu)  Then pdtgu = ''
		If IsNull(itcls)  Then itcls = ''
		
		If IsNull(stemp)  Then stemp = ''
		If IsNull(frmm)  Then frmm = ''
		If IsNull(tomm)  Then tomm = ''
		
		For ix = 2 To 5
			ii = Pos(stemp,',')
			If Len(stemp) = 0 Then Exit
			
			If ii > 0 Then 
				syear[ix] = Left(stemp,ii - 1 )
				stemp = Mid(stemp,ii+1)
			Else		
				ix = 5		
				syear[ix] = stemp
			End If	
		
			IF	f_datechk(syear[ix]+'0101') = -1 then
				f_message_chk(42,"비교년도 : YYYY")
				dw_ip.setfocus()
				REturn -1
			END IF
		Next
		
		IF	f_datechk(syear[1]+'0101') = -1 then
			MessageBox("확인","기준년도를 확인하세요!")
			dw_ip.setfocus()
			Return -1
		END IF
		
		IF	frmm = ''  then
			f_message_chk(1400,'판매월')      //필수입력항목
			dw_ip.setfocus()
			Return -1
		END IF
		
		IF	tomm = ''  then
			f_message_chk(1400,'판매월')      //필수입력항목
			dw_ip.setfocus()
			Return -1
		END IF
		
		////////////////////////////////// dw 선택및 트랜젝션 연결
		Choose Case tab_1.SelectedTab
			Case 1
				dw_select = tab_1.tabpage_1.dw_list_tab1
			   dw_print.dataObject = "d_sal_05694_p" 
		   Case 2
				dw_select = tab_1.tabpage_2.dw_list_tab2
			   dw_print.dataObject = "d_sal_05695_p" 
		   Case 3
				dw_select = tab_1.tabpage_4.dw_list_tab4
			   dw_print.dataObject = "d_sal_056951_p" 
		   Case 4
				dw_select = tab_1.tabpage_3.dw_list_tab3		
		      dw_print.dataObject = "d_sal_05696_p"  
      End Choose		
		dw_select.SetTransObject(sqlca)
		dw_print.SetTransObject(sqlca) 
		//////////////////////////////////////////////////////////////
		dw_print.SetRedraw(False)
		
		Choose Case tab_1.SelectedTab
			Case 1
				rtn = dw_print.retrieve(gs_sabu, syear[1],syear[2],syear[3],syear[4],syear[5],&
												 frmm,tomm,steam+'%', sarea+'%',pdtgu+'%',ls_silgu)
			Case 2,3,4
				rtn = dw_print.retrieve(gs_sabu, syear[1],syear[2],syear[3],syear[4],syear[5],&
												 frmm,tomm,steam+'%', sarea+'%', pdtgu+'%',itcls+'%',ls_silgu)
		End Choose		
		
		if rtn < 1	then
			f_message_chk(50,"")
			dw_ip.setfocus()
			dw_select.SetRedraw(True)
			return -1
		end if
		  dw_print.sharedata(dw_list)
		// title 년월 설정
		tx_steam = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steam) ', 1)"))
		tx_sarea = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
		tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
		tx_itcls  = trim(dw_ip.getitemstring(1, 'itclsnm'))
		
		If tx_steam = '' Then tx_steam = '전체'
		If tx_sarea = '' Then tx_sarea = '전체'
		If tx_pdtgu = '' Then tx_pdtgu = '전체'
		If IsNull(tx_itcls) Or tx_itcls = '' Then tx_itcls = '전체'
		
		dw_select.Object.tx_syear.text = syear[1] + '년도'
		dw_select.Object.tx_month.text = frmm + '월 - '  + tomm + '월'
		dw_select.Object.tx_steamcd.text = tx_steam
		dw_select.Object.tx_sarea.text = tx_sarea
		dw_select.Object.tx_pdtgu.text = tx_pdtgu
		dw_select.Object.tx_itcls.text = tx_itcls
end if

dw_print.SetRedraw(True)

Return 1


end function

on w_sal_05694.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_05694.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'sdate',syymm)

dw_ip.setitem(1,'sfrmm','01')
dw_ip.setitem(1,'stomm',mid(f_today(),5,2))

dw_ip.SetFocus()

dw_select = Create datawindow       // 조회용 

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_05694
integer taborder = 20
end type

type p_exit from w_standard_print`p_exit within w_sal_05694
integer taborder = 50
end type

type p_print from w_standard_print`p_print within w_sal_05694
integer taborder = 30
end type

event p_print::clicked;gi_page = 1
	
CHOOSE CASE tab_1.selectedtab
	CASE 1
		If tab_1.tabpage_1.dw_list_tab1.rowcount() > 0 then
			gi_page = tab_1.tabpage_1.dw_list_tab1.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_1.dw_list_tab1)
		End If
	CASE 2
		IF tab_1.tabpage_2.dw_list_tab2.rowcount() > 0 then
			gi_page = tab_1.tabpage_2.dw_list_tab2.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_2.dw_list_tab2)
		End If
	CASE 4
		IF tab_1.tabpage_3.dw_list_tab3.rowcount() > 0 then
			gi_page = tab_1.tabpage_3.dw_list_tab3.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_3.dw_list_tab3)
		End If
	CASE 3
		IF tab_1.tabpage_4.dw_list_tab4.rowcount() > 0 then
			gi_page = tab_1.tabpage_4.dw_list_tab4.GetItemNumber(1,"last_page")
			OpenWithParm(w_print_options, tab_1.tabpage_4.dw_list_tab4)
		End If
END CHOOSE

end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_05694
integer taborder = 10
end type







type st_10 from w_standard_print`st_10 within w_sal_05694
end type



type dw_print from w_standard_print`dw_print within w_sal_05694
string dataobject = "d_sal_05694_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05694
integer x = 69
integer y = 180
integer width = 4251
integer height = 268
integer taborder = 70
string dataobject = "d_sal_05697_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

this.accepttext()
nRow = GetRow()

if this.GetColumnName() = 'itcls' then
	sIttyp = '1'
	
	if tab_1.selectedtab = 3 then
		OpenWithParm(w_ittyp_popup3, '1')
	else
		OpenWithParm(w_ittyp_popup, '1')
	end if
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if
end event

event dw_ip::itemchanged;string cvcodnm , ls_gubun
string itclsnm,itcls,s_itnbr, s_itdsc, s_ispec
string s_name,s_itt,snull,get_nm

Choose Case  GetColumnName() 
	Case 'itcls'
		s_name = Trim(this.gettext())
      s_itt  = '1'
      IF s_name = "" OR IsNull(s_name) THEN 	
		   This.setitem(1, 'itclsnm', snull)
		   RETURN 
	   END IF
	
      SELECT "ITNCT"."TITNM"  
        INTO :get_nm  
        FROM "ITNCT"  
       WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
             ( "ITNCT"."ITCLS" = :s_name ) ;

   	IF SQLCA.SQLCODE <> 0 THEN
		   this.TriggerEvent(rbuttondown!)
		   if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
			   This.setitem(1, 'itcls', snull)
			   This.setitem(1, 'itclsnm', snull)
			   RETURN 1
         else
			   this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
			   this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
			   this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
            Return 1			
         end if
      ELSE
		   This.setitem(1, 'itclsnm', get_nm)
      END IF
	Case 'gubun'
		ls_gubun = this.GetText()
		   
			tab_1.tabpage_1.dw_list_tab1.setredraw(false) 
			tab_1.tabpage_2.dw_list_tab2.setredraw(false)
			tab_1.tabpage_4.dw_list_tab4.setredraw(false)
			tab_1.tabpage_3.dw_list_tab3.setredraw(false)
       
		if ls_gubun = '1' then
			tab_1.tabpage_1.dw_list_tab1.dataobject = 'd_sal_05694'
			tab_1.tabpage_2.dw_list_tab2.dataobject = 'd_sal_05695'
			tab_1.tabpage_4.dw_list_tab4.dataobject = 'd_sal_056951'
			tab_1.tabpage_3.dw_list_tab3.dataobject = 'd_sal_05696'
		else
			tab_1.tabpage_1.dw_list_tab1.dataobject = 'd_sal_05697'
			tab_1.tabpage_2.dw_list_tab2.dataobject = 'd_sal_05698'
			tab_1.tabpage_4.dw_list_tab4.dataobject = 'd_sal_056981'
			tab_1.tabpage_3.dw_list_tab3.dataobject = 'd_sal_05699'
		end if
		 
		   tab_1.tabpage_1.dw_list_tab1.settransobject(sqlca) 
			tab_1.tabpage_2.dw_list_tab2.settransobject(sqlca)
			tab_1.tabpage_4.dw_list_tab4.settransobject(sqlca)
			tab_1.tabpage_3.dw_list_tab3.settransobject(sqlca)
			
			tab_1.tabpage_1.dw_list_tab1.setredraw(true) 
			tab_1.tabpage_2.dw_list_tab2.setredraw(true)
			tab_1.tabpage_4.dw_list_tab4.setredraw(true)
			tab_1.tabpage_3.dw_list_tab3.setredraw(true)
		
End Choose























end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3)
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
//		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	

end event

type dw_list from w_standard_print`dw_list within w_sal_05694
boolean visible = false
integer x = 928
integer y = 2228
integer width = 585
integer height = 344
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type tab_1 from tab within w_sal_05694
integer x = 87
integer y = 492
integer width = 4498
integer height = 1820
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
alignment alignment = right!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
end on

event selectionchanged;Choose Case tab_1.SelectedTab
	Case 1
		dw_ip.Modify('itcls.protect = 1')
		dw_ip.Modify("itcls.background.color = '"+String(Rgb(192,192,192))+"'")
	Case 2
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
	Case 3
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
	Case 4 
		dw_ip.Modify('itcls.protect = 0')
		dw_ip.Modify("itcls.background.color = '"+String(Rgb(255,255,0))+"'")
End Choose		

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4462
integer height = 1708
long backcolor = 32106727
string text = "대분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list_tab1 dw_list_tab1
end type

on tabpage_1.create
this.dw_list_tab1=create dw_list_tab1
this.Control[]={this.dw_list_tab1}
end on

on tabpage_1.destroy
destroy(this.dw_list_tab1)
end on

type dw_list_tab1 from datawindow within tabpage_1
event u_key pbm_dwnkey
integer width = 4462
integer height = 1712
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05694"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4462
integer height = 1708
long backcolor = 32106727
string text = "중분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list_tab2 dw_list_tab2
end type

on tabpage_2.create
this.dw_list_tab2=create dw_list_tab2
this.Control[]={this.dw_list_tab2}
end on

on tabpage_2.destroy
destroy(this.dw_list_tab2)
end on

type dw_list_tab2 from datawindow within tabpage_2
event u_key pbm_dwnkey
integer width = 4462
integer height = 1708
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05695"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4462
integer height = 1708
long backcolor = 32106727
string text = "소분류별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list_tab4 dw_list_tab4
end type

on tabpage_4.create
this.dw_list_tab4=create dw_list_tab4
this.Control[]={this.dw_list_tab4}
end on

on tabpage_4.destroy
destroy(this.dw_list_tab4)
end on

type dw_list_tab4 from datawindow within tabpage_4
integer width = 4462
integer height = 1704
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_056951"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4462
integer height = 1708
long backcolor = 32106727
string text = "제품별 현황"
long tabtextcolor = 33554432
long tabbackcolor = 80859087
long picturemaskcolor = 536870912
dw_list_tab3 dw_list_tab3
end type

on tabpage_3.create
this.dw_list_tab3=create dw_list_tab3
this.Control[]={this.dw_list_tab3}
end on

on tabpage_3.destroy
destroy(this.dw_list_tab3)
end on

type dw_list_tab3 from datawindow within tabpage_3
event u_key pbm_dwnkey
integer width = 4462
integer height = 1708
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sal_05696"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event u_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
end choose

end event


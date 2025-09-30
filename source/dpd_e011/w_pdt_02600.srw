$PBExportHeader$w_pdt_02600.srw
$PBExportComments$부하현황(자료)
forward
global type w_pdt_02600 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02600
end type
end forward

global type w_pdt_02600 from w_standard_print
string title = "부하현황(자료)"
rr_1 rr_1
end type
global w_pdt_02600 w_pdt_02600

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();  String Go1,Go2,GuGan1,GuGan2, gubun, prtgbn, pordno
	
		
dw_ip.AcceptText()
dw_list.Reset()
	
gubun   	=  dw_ip.GetItemString(1,"gubun")	
prtgbn   	=  dw_ip.GetItemString(1,"prtgbn")		
Go1   		=  dw_ip.GetItemString(1,"jo1")
Go2   		=  dw_ip.GetItemString(1,"jo2")
GuGan1 	=  dw_ip.GetItemString(1,"gu1")
GuGan2 	=  dw_ip.GetItemString(1,"gu2")
pordno 	=  dw_ip.GetItemString(1,"pordno")	
	
	IF Go1 = '' OR ISNULL(Go1) THEN
		go1 = '.'
	END IF	
	IF Go2 = '' OR ISNULL(Go2) THEN
		go2 = 'zzzzzz'
	END IF	
	IF GuGan1 = '' OR ISNULL(GuGan1) THEN
       SELECT Min(RESCAL.GUGAN) 
	     INTO: GuGan1
	     FROM RESCAL ;  	
	END IF	
	
	IF GuGan2 = '' OR ISNULL(GuGan2) THEN
		SELECT Max(RESCAL.GUGAN) 
	     INTO: GuGan2
	     FROM RESCAL ;  	
	END IF	
	
	IF Go1 > Go2 THEN
		MessageBox("확인","코드범위를 확인하세요")
		dw_ip.SetColumn("jo1")
		dw_ip.SetFocus()
		return -1
	END IF	
	
	IF GuGan1 > GuGan2 THEN
		MessageBox("확인","구간범위를 확인하세요")
		dw_ip.SetColumn("gu1")
		dw_ip.SetFocus()
		return -1
		
	END IF	
	
	if 		gubun = '1' and prtgbn = '1' then
				dw_list.dataobject = 'd_pdt_02600_03'
				dw_print.dataobject = 'd_pdt_02600_03_p'
	elseif 	gubun = '2' and prtgbn = '1' then
				dw_list.dataobject = 'd_pdt_02600_02'
				dw_print.dataobject = 'd_pdt_02600_02_p'
	elseif 	gubun = '3' and prtgbn = '1' then
				dw_list.dataobject = 'd_pdt_02600_01'
				dw_print.dataobject = 'd_pdt_02600_01_p'
	elseif 	gubun = '4' and prtgbn = '1' then
				dw_list.dataobject = 'd_pdt_02600_04'
				dw_print.dataobject = 'd_pdt_02600_04_p'
	Elseif 	gubun = '1' and prtgbn = '2' then
				dw_list.dataobject = 'd_pdt_02600_031'
				dw_print.dataobject = 'd_pdt_02600_031_p'
	elseif 	gubun = '2' and prtgbn = '2' then
				dw_list.dataobject = 'd_pdt_02600_021'
				dw_print.dataobject = 'd_pdt_02600_021_p'
	elseif 	gubun = '3' and prtgbn = '2' then
				dw_list.dataobject = 'd_pdt_02600_011'
				dw_print.dataobject = 'd_pdt_02600_011_p'
	elseif 	gubun = '4' and prtgbn = '2' then
				dw_list.dataobject = 'd_pdt_02600_041'
				dw_print.dataobject = 'd_pdt_02600_041_p'
	Elseif 	gubun = '1' and prtgbn = '3' then
				dw_list.dataobject = 'd_pdt_02600_053'
				dw_print.dataobject = 'd_pdt_02600_053_p'
	elseif 	gubun = '2' and prtgbn = '3' then
				dw_list.dataobject = 'd_pdt_02600_052'
				dw_print.dataobject = 'd_pdt_02600_052_p'
	elseif 	gubun = '3' and prtgbn = '3' then
				dw_list.dataobject = 'd_pdt_02600_051'
				dw_print.dataobject = 'd_pdt_02600_051_p'
	elseif 	gubun = '4' and prtgbn = '3' then
				dw_list.dataobject = 'd_pdt_02600_054'	
				dw_print.dataobject = 'd_pdt_02600_054_p'	
	elseif   gubun = '5' then
				dw_list.dataobject = 'd_pdt_02605_05'
				dw_print.dataobject = 'd_pdt_02605_05'
	end if
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	
	dw_list.SetRedraw(false)
	
	if  gubun = '5' then
		IF  dw_print.Retrieve(gs_sabu,0,99,pordno) < 1 THEN
			  f_message_chk(50,'')
			  return -1
		Else
			dw_list.Retrieve(gs_sabu,0,99,pordno)
		END IF		
	Else
		 IF  dw_print.Retrieve(gs_sabu,Go1,Go2,GuGan1,GuGan2 ) < 1 THEN
			  f_message_chk(50,'')
			  return -1
		 END IF
		
		 if gubun = '4' then
			 dw_print.object.roslt_name.text = f_get_reffer('21', go1)
		 End if
	end if
	
	dw_print.sharedata(dw_list)
	
	dw_list.SetRedraw(true)
return 1
end function

on w_pdt_02600.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_02600
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_pdt_02600
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_pdt_02600
integer x = 4256
end type

event p_print::clicked;IF dw_list.rowcount() > 0 and dw_ip.getitemstring(1, "gubun") < '5' then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02600
integer x = 3909
end type







type st_10 from w_standard_print`st_10 within w_pdt_02600
end type

type gb_10 from w_standard_print`gb_10 within w_pdt_02600
integer x = 37
integer y = 2444
integer width = 96
integer height = 144
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pdt_02600
integer x = 3680
string dataobject = "d_pdt_02600_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02600
integer x = 55
integer y = 72
integer width = 2935
integer height = 340
string dataobject = "d_pdt_02600_00_1"
end type

event dw_ip::ue_pressenter;send(handle(this), 256, 9, 0)

return 1
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String sJoCode,Joname,snull,sGuCode,sGugan, sgubun

sgubun = getitemstring(1, "gubun")

if 	this.getcolumnname() = "gubun" then
	setitem(1, "jo1", snull)
	setitem(1, "joname1", snull)
	setitem(1, "jo2", snull)
	setitem(1, "joname2", snull)	
Elseif THIS.GetColumnName() = "prtgbn" THEN
	setitem(1, "gu1" ,'')
	setitem(1, "gu2" ,'')	
elseIF THIS.GetColumnName() = "jo1" THEN
	 sJoCode = this.GetText()
	 
	IF sJoCode = "" or isnull(sJoCode) then 
		this.setitem(1,"jo1",snull)
		this.setitem(1,"joname1",snull)		
		return
	END IF
	
	choose case sgubun 
			 case '1'
					this.setitem(1,"joname1",f_get_reffer('03',sjocode))
			 case '2'
					SELECT  JOMAST.JONAM
					  INTO :Joname
					  FROM  JOMAST 
					 WHERE  JOMAST.JOCOD = :sJoCode ;
 
					this.setitem(1,"joname1",Joname)
			 case '3'
					SELECT  wcdsc
					  INTO :Joname
					  FROM  wrkctr
					 WHERE  wkctr = :sJoCode ;
 
					this.setitem(1,"joname1",Joname)								
			 case '4'
					this.setitem(1,"joname1",f_get_reffer('21',sjocode))				
	End choose
	
ELSEIF THIS.GetColumnName() = "jo2" THEN
	 sJoCode = this.GetText()
	 
	IF sJoCode = "" or isnull(sJoCode) then 
		this.setitem(1,"jo2",snull)
		this.setitem(1,"joname2",snull)		
		return
	END IF

	choose case sgubun 
			 case '1'
					this.setitem(1,"joname2",f_get_reffer('03',sjocode))
			 case '2'
					SELECT  JOMAST.JONAM
					  INTO :Joname
					  FROM  JOMAST 
					 WHERE  JOMAST.JOCOD = :sJoCode ;
 
					this.setitem(1,"joname2",Joname)
			 case '3'
					SELECT  wcdsc
					  INTO :Joname
					  FROM  wrkctr
					 WHERE  wkctr = :sJoCode ;
 
					this.setitem(1,"joname2",Joname)								
			 case '4'
					this.setitem(1,"joname2",f_get_reffer('21',sjocode))				
	End choose

ELSEIF this.GetColumnName() = "gu1" THEN      
	 sGuCode = THIS.GetText()
	 
	if getitemstring(1, "prtgbn") = '3' then  // 일자기준
		  if f_datechk(sGucode) = -1 then
			 MessageBox("확인","일자가 부정확합니다.")
			 dw_ip.setitem(1, "gu1", '')
			 dw_ip.SetColumn("gu1") 
			 dw_ip.SetFocus()
			 Return 1
		  End if
	Else													// 구간기준
		 IF sGuCode = '' OR ISNULL(sGuCode) THEN
			 MessageBox("확인","구간을 입력하세요")
			 dw_ip.SetColumn("gu1") 
			 dw_ip.SetFocus()
			 Return 1 
		 ELSE
			 SELECT RESCAL.GUGAN 
			  INTO: sGugan	
			  FROM RESCAL   	
			 WHERE RESCAL.GUGAN = :sGuCode ; 
			 IF SQLCA.SQLCODE <> 0 THEN
				 MessageBox("확인","등록되어있지 않은 구간입니다")
				 dw_ip.SetItem(1,"gu1",SNull)
				 dw_ip.SetFocus()
				 Return 1 
			 END IF	
		 END IF	
	End if
ELSEIF this.GetColumnName() = "gu2" THEN      
	 sGuCode = THIS.GetText()
	 
	if getitemstring(1, "prtgbn") = '3' then  // 일자기준
		  if f_datechk(sGucode) = -1 then
			 MessageBox("확인","일자가 부정확합니다.")
			 dw_ip.setitem(1, "gu1", '')
			 dw_ip.SetColumn("gu1") 
			 dw_ip.SetFocus()
			 Return 1
		  End if
	Else													// 구간기준	 
		 IF sGuCode = '' OR ISNULL(sGuCode) THEN
			 MessageBox("확인","구간을 입력하세요")
			 dw_ip.SetColumn("gu2") 
			 dw_ip.SetFocus()
			 Return 1 
		 ELSE
			 SELECT RESCAL.GUGAN 
			  INTO: sGugan	
			  FROM RESCAL   	
			 WHERE RESCAL.GUGAN = :sGuCode ; 
			 IF SQLCA.SQLCODE <> 0 THEN
				 MessageBox("확인","등록되어있지 않은 구간입니다")
				 dw_ip.SetItem(1,"gu2",SNull)
				 dw_ip.SetFocus()
				 Return 1 
			 END IF	
		 END IF	
	End if
END IF	
	
end event

event dw_ip::rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''

string sgubun

sgubun = getitemstring(1, "gubun")
IF this.GetColumnName() = "jo1" THEN
	choose case sgubun
			 case '1'
					gs_code = '03'
					Open(w_reffpf_all_popup)				
			 case '2'
				   Open(w_jomas_popup)				
			 case '3'
				   Open(w_workplace_popup)								
			 case '4'
					gs_code = '21'
					Open(w_reffpf_all_popup)
	End choose				
	
   IF isnull(gs_code) OR gs_code = '' THEN RETURN

   dw_ip.SetItem(1,"jo1",gs_code)
   dw_ip.SetItem(1,"joname1",gs_codename)
ELSEIF this.GetColumnName() = "jo2" THEN
	choose case sgubun
			 case '1'
					gs_code = '03'
					Open(w_reffpf_all_popup)				
			 case '2'
				   Open(w_jomas_popup)				
			 case '3'
				   Open(w_workplace_popup)								
			 case '4'
					gs_code = '21'
					Open(w_reffpf_all_popup)
	End choose				
	
   IF isnull(gs_code) OR gs_code = '' THEN RETURN

   dw_ip.SetItem(1,"jo2",gs_code)
   dw_ip.SetItem(1,"joname2",gs_codename)

ELSEIF this.GetColumnName() = "gu1" THEN
	if getitemstring(1, "prtgbn") = '3' then return
	Open(w_gugan_popup)
   
	IF isnull(gs_code) OR gs_code = '' THEN RETURN
   dw_ip.SetItem(1,"gu1",gs_code) 

ELSEIF this.GetColumnName() = "gu2" THEN
	if getitemstring(1, "prtgbn") = '3' then return	
	Open(w_gugan_popup)
   
	IF isnull(gs_code) OR gs_code = '' THEN RETURN
   dw_ip.SetItem(1,"gu2",gs_code) 
	
ELSEIF this.GetColumnName() = "pordno" THEN
	Open(w_jisi_popup)
   
	IF isnull(gs_code) OR gs_code = '' THEN RETURN
   dw_ip.SetItem(1,"pordno",gs_code) 	

END IF
end event

type dw_list from w_standard_print`dw_list within w_pdt_02600
integer y = 440
integer width = 4562
integer height = 1804
string dataobject = "d_pdt_02600_03"
boolean controlmenu = true
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_02600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 420
integer width = 4585
integer height = 1820
integer cornerheight = 40
integer cornerwidth = 55
end type


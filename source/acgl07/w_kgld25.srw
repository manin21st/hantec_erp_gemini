$PBExportHeader$w_kgld25.srw
$PBExportComments$거래처(관리번호)별 거래현황 조회 출력
forward
global type w_kgld25 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld25
end type
type rb_2 from radiobutton within w_kgld25
end type
type gb_1 from groupbox within w_kgld25
end type
type rr_2 from roundrectangle within w_kgld25
end type
end forward

global type w_kgld25 from w_standard_print
integer x = 0
integer y = 0
string title = "거래처(관리번호)별 거래현황 조회 출력"
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_2 rr_2
end type
global w_kgld25 w_kgld25

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_cond_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();string sSaupj, sDatefrom, sDateto, scustfrom, scustto, sacc1_cd, sacc2_cd, sdatef, sdatet, &
       syear,sgaej,sgaejf,sgaejt

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))
sDatefrom = dw_ip.GetItemString(1,"k_symd")
sDateto = dw_ip.GetItemString(1,"k_eymd")
sAcc1_cd = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"sacc1"))
sAcc2_cd = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"sacc2"))
scustfrom = dw_ip.GetItemString(dw_ip.GetRow(),"scust")
scustto = dw_ip.GetItemString(dw_ip.GetRow(),"ecust")

//필수 입력항목 check
IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF trim(sDatefrom) = "" or isnull(sDatefrom) then 
	f_messagechk(1,"회계일자")
	dw_ip.SetFocus()
	dw_ip.setcolumn("k_symd")
	Return -1
elseif f_datechk(sDatefrom) = -1 then
	f_messagechk(21,"회계일자")
	dw_ip.SetFocus()
	dw_ip.setcolumn("k_symd")
	Return -1
end if

IF trim(sDateto) = "" or isnull(sDateto) then 
	f_messagechk(1,"회계일자")
	dw_ip.SetFocus()
	dw_ip.setcolumn("k_eymd")
	Return -1
elseif f_datechk(sDateto) = -1 then
	f_messagechk(21,"회계일자")
	dw_ip.SetFocus()
	dw_ip.setcolumn("k_eymd")
	Return -1
end if

IF sDatefrom > sDateto THEN
	f_messagechk(26,"회계일자")
	dw_ip.SetFocus()
	dw_ip.setcolumn("k_symd")
	Return -1
ELSE
	syear = Left(sdatefrom,4)
	sdatef = left(sdatefrom,4)+'/'+mid(sdatefrom,5,2)+'/'+right(sdatefrom,2)
	sdatet = left(sdateto,4)+'/'+mid(sdateto,5,2)+'/'+right(sdateto,2)
END IF

sgaej = sacc1_cd + sacc2_cd

IF trim(sgaej) = "" or isnull(sgaej) then 
	f_messagechk(1,"계정과목")
	dw_ip.SetFocus()
	dw_ip.setcolumn("sacc1")
	Return -1
END IF

sgaejf = lstr_account.fracc1_cd + lstr_account.fracc2_cd
sgaejt = lstr_account.toacc1_cd + lstr_account.toacc2_cd

if isnull(scustfrom) or scustfrom = '' then scustfrom = '0'
if isnull(scustto) or scustto = '' then scustto = 'zzzzzz'

IF dw_print.Retrieve(sabu_f,sabu_t,syear,sdatefrom,sdateto,sgaejf,sgaejt,sgaej,scustfrom,scustto) <= 0 THEN
	F_MessageChk(14,'')
	Return -1
END IF

dw_print.sharedata(dw_list)

return 1
end function

public function integer wf_cond_chk (string scolname, string scolvalue);
String snull,gaej,sname1,sname2,sgu,scustnm

SetNull(snull)

IF scolname ="datef" THEN
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"k_symd",snull)
		Return -1
	END IF
END IF

IF scolname ="datef" THEN
	
	IF f_datechk(scolvalue) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"k_eymd",snull)
		Return -1
	END IF
END IF

IF scolname = 'sacc1'	then	

	gaej = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2")
	
	IF gaej ="" OR IsNull(gaej) THEN 
		dw_ip.setitem(1,"sacc1",snull)
		dw_ip.setitem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		RETURN 1
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM","KFZ01OM0"."GBN6","KFZ01OM0"."GBN1",
			 "KFZ01OM0"."FRACC1_CD","KFZ01OM0"."FRACC2_CD","KFZ01OM0"."TOACC1_CD","KFZ01OM0"."TOACC2_CD"
		INTO :sname1,  :sname2,  :sgu,  :lstr_account.gbn1,:lstr_account.fracc1_cd,:lstr_account.fracc2_cd,
		     :lstr_account.toacc1_cd,:lstr_account.toacc2_cd
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND ( "KFZ01OM0"."ACC2_CD" = :gaej ) ;  

	IF SQLCA.SQLCODE <> 0 THEN 
		f_Messagechk(25,"")
		dw_ip.setitem(1,"sacc1",snull)
		dw_ip.setitem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		Return -1
	ELSEIF sgu <> 'Y' THEN
		f_Messagechk(30,"")
		dw_ip.setitem(1,"sacc1",snull)
		dw_ip.setitem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		Return -1
	ELSE
		dw_ip.SetItem(1,"saccname",sname2)
	END IF
END IF 

IF scolname = 'sacc2'	then
	
	gaej = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	
	IF gaej ="" OR IsNull(gaej) THEN 
		dw_ip.setitem(1,"sacc1",snull)
		dw_ip.setitem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		RETURN 1
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM","KFZ01OM0"."GBN6","KFZ01OM0"."GBN1",
			 "KFZ01OM0"."FRACC1_CD","KFZ01OM0"."FRACC2_CD","KFZ01OM0"."TOACC1_CD","KFZ01OM0"."TOACC2_CD"
		INTO :sname1,  :sname2,  :sgu,  :lstr_account.gbn1,:lstr_account.fracc1_cd,:lstr_account.fracc2_cd,
		     :lstr_account.toacc1_cd,:lstr_account.toacc2_cd
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :gaej) AND ( "KFZ01OM0"."ACC2_CD" = :scolvalue ) ;  

	IF SQLCA.SQLCODE <> 0 THEN 
		f_Messagechk(25,"")
		dw_ip.setitem(1,"sacc1",snull)
		dw_ip.setitem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		Return -1
	ELSEIF sgu <> 'Y' THEN
		f_Messagechk(30,"")
		dw_ip.setitem(1,"sacc1",snull)
		dw_ip.setitem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		Return -1
	ELSE
		dw_ip.SetItem(1,"saccname",sname2)
	END IF	
END IF 

IF scolname ="scust" THEN
	IF scolvalue = "" OR IsNull(scolvalue) THEN
		dw_ip.SetItem(dw_ip.GetRow(),"scust",snull)
		dw_ip.SetItem(dw_ip.GetRow(),"scustname",snull)
	ELSE
		IF IsNull(lstr_account.gbn1) OR lstr_account.gbn1 ="" THEN lstr_account.gbn1 ='%'
		
		SELECT "KFZ04OM0"."PERSON_NM"
   		INTO :scustnm
   		FROM "KFZ04OM0"  
   		WHERE (( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) OR 
					( "KFZ04OM0"."PERSON_GU" = '99')) AND
					( "KFZ04OM0"."PERSON_CD" = :scolvalue) ;
		IF SQLCA.SQLCODE <> 0 THEN
			sle_msg.text ="입력하신 계정이 관리하는 거래처를 입력해야 합니다.!!"
			MessageBox("확 인","거래처를 확인하세요.!!")
			dw_ip.SetItem(dw_ip.GetRow(),"scust",snull)
			dw_ip.SetItem(dw_ip.GetRow(),"scustname",snull)
			Return -1
		ELSE
			dw_ip.SetItem(dw_ip.GetRow(),"scustname",scustnm)
		END IF			
	END IF
END IF

IF scolname ="ecust" THEN
	IF scolvalue = "" OR IsNull(scolvalue) THEN
		dw_ip.SetItem(dw_ip.GetRow(),"ecust",snull)
		dw_ip.SetItem(dw_ip.GetRow(),"ecustname",snull)
	ELSE
		IF IsNull(lstr_account.gbn1) OR lstr_account.gbn1 ="" THEN lstr_account.gbn1 ='%'
		
		SELECT "KFZ04OM0"."PERSON_NM"
   		INTO :scustnm
   		FROM "KFZ04OM0"  
   		WHERE (( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) OR 
					( "KFZ04OM0"."PERSON_GU" = '99')) AND
					( "KFZ04OM0"."PERSON_CD" = :scolvalue) ;
		IF SQLCA.SQLCODE <> 0 THEN
			sle_msg.text ="입력하신 계정이 관리하는 거래처를 입력해야 합니다.!!"
			MessageBox("확 인","거래처를 확인하세요.!!")
			dw_ip.SetItem(dw_ip.GetRow(),"ecust",snull)
			dw_ip.SetItem(dw_ip.GetRow(),"ecustname",snull)
			Return -1
		ELSE
			dw_ip.SetItem(dw_ip.GetRow(),"ecustname",scustnm)
		END IF			
	END IF
END IF

Return 1
end function

on w_kgld25.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kgld25.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.SetItem(1,"saupj",gs_saupj)
dw_ip.setitem(1,"k_symd", left(f_today(), 6) + "01")
dw_ip.setitem(1,"k_eymd", f_today())

dw_ip.SetColumn("k_symd")
dw_ip.SetFocus()


end event

type p_preview from w_standard_print`p_preview within w_kgld25
end type

type p_exit from w_standard_print`p_exit within w_kgld25
end type

type p_print from w_standard_print`p_print within w_kgld25
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld25
end type



type sle_msg from w_standard_print`sle_msg within w_kgld25
integer x = 421
integer width = 1947
end type



type st_10 from w_standard_print`st_10 within w_kgld25
end type



type dw_print from w_standard_print`dw_print within w_kgld25
integer x = 3401
integer y = 0
string dataobject = "dw_kgld252_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld25
integer x = 37
integer width = 3419
integer height = 224
string dataobject = "dw_kgld251"
end type

event dw_ip::rbuttondown;
IF this.GetColumnName() = "sacc1" OR this.GetColumnName() = "sacc2" THEN
	SetNull(lstr_account.acc1_cd);			SetNull(lstr_account.acc2_cd);
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	END IF
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	END IF
	
	lstr_account.acc1_cd = Trim(lstr_account.acc1_cd)
	lstr_account.acc2_cd = Trim(lstr_account.acc2_cd)

	Open(W_KFZ01OM0_POPUP1)
	
	IF IsNull(lstr_account.acc1_cd) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"saccname",lstr_account.acc2_nm)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName() = "scust" OR this.GetColumnName() ="ecust" THEN
	SetNull(lstr_custom.code);			SetNull(lstr_custom.name);

	IF this.GetColumnName() ="scust" THEN
		lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(), "scust")
	ELSE
		lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(), "ecust")
	END IF
  
   IF IsNull(lstr_custom.code) then
      lstr_custom.code = ""
   END IF
	
   lstr_custom.code = Trim(lstr_custom.code)
   SetNull(lstr_custom.name)
	
	IF IsNull(lstr_account.gbn1) OR lstr_account.gbn1 ="" THEN lstr_account.gbn1 ='%'
	
   OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)
	
	IF IsNull(lstr_custom.code) THEN RETURN 
	
	IF this.GetColumnName() ="scust" THEN
		dw_ip.SetItem(dw_ip.GetRow(), "scust",lstr_custom.code)
		dw_ip.SetItem(dw_ip.Getrow(), "scustname", lstr_custom.name)
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(), "ecust",lstr_custom.code)
		dw_ip.SetItem(dw_ip.Getrow(), "ecustname", lstr_custom.name)
	END IF
END IF
end event

event dw_ip::itemchanged;
sle_msg.text =""

IF this.GetColumnName() ="k_symd" THEN
	
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
END IF

IF this.GetColumnName() ="k_eymd" THEN
	
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
END IF

IF wf_cond_chk(this.GetColumnName(),this.GetText()) = -1 THEN
	Return 1
END IF



end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kgld25
integer x = 59
integer y = 252
integer width = 4530
integer height = 1936
string title = "거래처별 거래현황"
string dataobject = "dw_kgld252"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)
end event

event dw_list::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

type rb_1 from radiobutton within w_kgld25
integer x = 3525
integer y = 48
integer width = 334
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "명 칭 순"
boolean checked = true
end type

event clicked;dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.setsort("saup_nm a")
   dw_list.sort()
END IF

dw_list.SetRedraw(True)

end event

type rb_2 from radiobutton within w_kgld25
integer x = 3525
integer y = 116
integer width = 334
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "코 드 순"
end type

event clicked;dw_list.SetRedraw(False)

IF rb_2.Checked =True THEN
	dw_list.setsort("saup_no a")
	
   dw_list.sort()
   
END IF

dw_list.SetRedraw(True)

end event

type gb_1 from groupbox within w_kgld25
integer x = 3465
integer width = 443
integer height = 216
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "정렬"
end type

type rr_2 from roundrectangle within w_kgld25
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 240
integer width = 4576
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_kfia05a.srw
$PBExportComments$차입금 조회 출력
forward
global type w_kfia05a from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia05a
end type
end forward

global type w_kfia05a from w_standard_print
integer x = 0
integer y = 0
string title = "차입금 조회 출력"
rr_1 rr_1
end type
global w_kfia05a w_kfia05a

type variables
String sacc1,sacc2,sbnkf,sbnkt,sdatef,sdatet,sgaejnm,sbnknmf,sbnknmt
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_chk_cond ()
end prototypes

public function integer wf_retrieve ();Int ll_rtn_chk

IF dw_ip.AcceptText() = -1 THEN RETURN -1

if WF_CHK_COND() = -1 THEN Return -1

ll_rtn_chk =dw_print.Retrieve(sabu_f,sabu_t,sacc1,sacc2,sdatef,sbnkf,sbnkt,sgaejnm,sbnknmf,sbnknmt)

IF ll_rtn_chk <=0 THEN
	f_messagechk(14,"")
	dw_ip.SetFocus()
	//Return -1
	dw_list.insertrow(0)
END IF
  dw_print.sharedata(dw_list)

Return 1
end function

public function integer wf_chk_cond ();String snull

SetNull(snull)

dw_ip.AcceptText()

sacc1 =dw_ip.GetItemString(dw_ip.Getrow(),"acc1f")
sacc2 =dw_ip.GetItemString(dw_ip.Getrow(),"acc2f")

sbnkf =dw_ip.GetItemString(dw_ip.Getrow(),"bankf")
sbnkt =dw_ip.GetItemString(dw_ip.Getrow(),"bankt")

sdatef =Trim(dw_ip.GetItemString(dw_ip.Getrow(),"datef"))
sdatet =Trim(dw_ip.GetItemString(dw_ip.Getrow(),"datet"))

IF sacc1 ="" OR IsNull(sacc1) THEN
	sacc1 ="%"
	sacc2 ="%"
END IF

IF sacc2 ="" OR IsNull(sacc2) THEN
	sacc2 ="%"
END IF

IF sacc1 ="%" THEN
	sgaejnm ="%"
ELSE
	sgaejnm =dw_ip.GetItemString(dw_ip.Getrow(),"accf_nm")
END IF

IF sdatef = "" or Isnull(sdatef) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("datef")
	dw_ip.SetFocus()
	Return -1
END IF

SELECT "KFZ04OM0"."PERSON_NM"  
   INTO :sbnknmf 
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
      	( "KFZ04OM0"."PERSON_CD" = :sbnkf )   ;
IF SQLCA.SQLCODE <> 0 THEN
	f_messagechk(20,"은행코드")
	dw_ip.SetItem(dw_ip.GetRow(),"bankf",snull)
	Return -1
END IF

SELECT "KFZ04OM0"."PERSON_NM"  
   INTO :sbnknmt 
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
      	( "KFZ04OM0"."PERSON_CD" = :sbnkt )   ;
IF SQLCA.SQLCODE <> 0 THEN
	f_messagechk(20,"은행코드")
	dw_ip.SetItem(dw_ip.GetRow(),"bankt",snull)
	Return -1
END IF


Return 1

end function

on w_kfia05a.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia05a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sbnk_min,sbnk_max

SELECT MIN("KFZ04OM0"."PERSON_CD"),MAX("KFZ04OM0"."PERSON_CD")  
   INTO :sbnk_min,:sbnk_max
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) ;
				
dw_ip.SetItem(dw_ip.GetRow(),"bankf",sbnk_min)
dw_ip.SetItem(dw_ip.Getrow(),"bankt",sbnk_max)
dw_ip.SetItem(dw_ip.GetRow(),"datef",f_today())
dw_ip.SetItem(dw_ip.GetRow(),"datet",String(today(),"yyyymmdd"))
dw_ip.SetItem(dw_ip.GetRow(),"gubun",'1')

dw_ip.SetColumn("acc1f")
dw_ip.Setfocus()

dw_list.SetTransObject(SQLCA)
end event

type p_preview from w_standard_print`p_preview within w_kfia05a
end type

type p_exit from w_standard_print`p_exit within w_kfia05a
end type

type p_print from w_standard_print`p_print within w_kfia05a
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia05a
end type







type st_10 from w_standard_print`st_10 within w_kfia05a
end type



type dw_print from w_standard_print`dw_print within w_kfia05a
string dataobject = "d_kfia05a_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia05a
integer x = 55
integer y = 40
integer width = 2199
integer height = 380
string dataobject = "d_kfia05a_2"
end type

event dw_ip::itemchanged;String snull,sgubun,sch_gu

SetNull(snull)
sle_msg.text =""

IF dwo.name ="acc1f" OR dwo.name ="acc2f" THEN
	IF dwo.name ="acc1f" THEN
		sacc1 = data
		sacc2 = dw_ip.GetItemString(dw_ip.GetRow(),"acc2f")
	ELSE 
		sacc1 = dw_ip.GetItemString(dw_ip.GetRow(),"acc1f")
		sacc2 = data
	END IF
	
	IF sacc1 ="" OR IsNull(sacc1) OR sacc2 ="" OR IsNull(sacc2) THEN RETURN 
	
	SELECT "KFZ01OM0"."GBN1","KFZ01OM0"."ACC2_NM","KFZ01OM0"."CH_GU" 
   	INTO :sgubun  ,:sgaejnm ,:sch_gu
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc1 ) AND  
      	   ( "KFZ01OM0"."ACC2_CD" = :sacc2 )   ;
	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"계정과목")
		dw_ip.SetItem(dw_ip.GetRow(),"acc1f",snull)
		dw_ip.SetItem(dw_ip.GetRow(),"acc2f",snull)
		dw_ip.SetItem(dw_ip.GetRow(),"accf_nm",snull)
		dw_ip.Setcolumn("acc1f")
		Return 1
	ELSE
//		IF sgubun = '6' OR sch_gu = 'Y' THEN
			dw_ip.SetItem(dw_ip.Getrow(),"accf_nm",sgaejnm)
//		ELSE
//			MessageBox("확 인","차입금을 조회할 수 없는 계정입니다.!!")
//			dw_ip.SetItem(dw_ip.GetRow(),"acc1f",snull)
//			dw_ip.SetItem(dw_ip.GetRow(),"acc2f",snull)
//			dw_ip.SetItem(dw_ip.GetRow(),"accf_nm",snull)
//			dw_ip.SetColumn("acc1f")
//			Return 1
//		END IF
	END IF
END IF

IF dwo.name ="bankf" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :sbnknmf 
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
      	   ( "KFZ04OM0"."PERSON_CD" = :data )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"은행코드")
		dw_ip.SetItem(dw_ip.GetRow(),"bankf",snull)
		Return 1
	END IF
END IF

IF dwo.name ="bankt" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :sbnknmt 
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
      	   ( "KFZ04OM0"."PERSON_CD" = :data )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"은행코드")
		dw_ip.SetItem(dw_ip.GetRow(),"bankt",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datef" THEN
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN 
	
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datet" THEN
	IF Trim(data) ="" OR IsNull(Trim(data)) THEN RETURN 
	
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

IF dwo.name ="gubun" THEN
	dw_ip.SetRedraw(False)
	IF data ='1' THEN
		dw_print.Title ="계정과목별 차입은행순"
		dw_print.DataObject ="d_kfia05a_p"
		dw_list.DataObject ="d_kfia05a"
	ELSEIF data ='2' THEN
		dw_print.Title ="만기일자별 차입은행순"
		dw_print.DataObject ="d_kfia05a_1_p"
		dw_list.DataObject ="d_kfia05a_1"
	ELSEIF data ='3' THEN
		dw_print.Title = "차입은행별 만기일자순"
		dw_print.DataObject ="d_kfia05a_0_p"
		dw_list.DataObject ="d_kfia05a_0"
	ELSEIF data ='4' THEN
		dw_print.Title = "용도구분별 차입은행순"
		dw_print.DataObject ="d_kfia05a_3_p"
		dw_list.DataObject ="d_kfia05a_3"
	ELSE
		MessageBox("확 인","출력구분을 입력하시요.!!")
		Return 1
	END IF
	dw_ip.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
END IF


end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)
SetNull(lstr_account.acc2_nm)

this.accepttext()

IF this.GetColumnName() ="acc1f"  THEN
	lstr_account.acc1_cd =dw_ip.GetItemString(1,"acc1f")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if

	OpenWithParm(W_KFZ01OM0_POPUP_GBN, '6')
	
	IF IsNull(lstr_account.acc1_cd) THEN 
		dw_ip.SetItem(1,"acc1f",snull)
		dw_ip.SetItem(1,"acc2f",snull)

		dw_ip.SetItem(1,"accf_nm",snull)
		RETURN
	END IF
	
//	IF lstr_account.gbn1 = '6' OR lstr_account.ch_gu = 'Y' THEN
		dw_ip.SetItem(1,"acc1f",lstr_account.acc1_cd)
		dw_ip.SetItem(1,"acc2f",lstr_account.acc2_cd)

		dw_ip.SetItem(1,"accf_nm",lstr_account.acc2_nm)
//	ELSE
//		MessageBox("확 인","차입금을 조회할 수 없는 계정입니다.!!")
//		dw_ip.SetItem(1,"acc1f",snull)
//		dw_ip.SetItem(1,"acc2f",snull)
//
//		dw_ip.SetItem(1,"accf_nm",snull)
//	END IF
END IF
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia05a
integer x = 69
integer y = 436
integer width = 4517
integer height = 1784
string dataobject = "d_kfia05a"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia05a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 424
integer width = 4549
integer height = 1812
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_kfia03a.srw
$PBExportComments$지급어음 조회 출력
forward
global type w_kfia03a from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia03a
end type
end forward

global type w_kfia03a from w_standard_print
integer x = 0
integer y = 0
string title = "지급어음 조회 출력"
rr_1 rr_1
end type
global w_kfia03a w_kfia03a

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32"

end prototypes

type variables
String sCustF,sCustT,sBnkF,sBnkT,sDateF,sDateT,sStatus,sCustFnm,sCustTnm,sBnknmf,sBnknmt,sStatus_nm
end variables

forward prototypes
public function integer wf_chk_cond ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_chk_cond ();
String sNull

SetNull(sNull)

dw_ip.AcceptText()

sCustF =dw_ip.GetItemString(dw_ip.Getrow(),"custf")
sCustT =dw_ip.GetItemString(dw_ip.Getrow(),"custt")

sBnkF  =dw_ip.GetItemString(dw_ip.Getrow(),"bankf")
sBnkT  =dw_ip.GetItemString(dw_ip.Getrow(),"bankf")

sDatef =dw_ip.GetItemString(dw_ip.Getrow(),"datef")
sDatet =dw_ip.GetItemString(dw_ip.Getrow(),"datet")

sStatus =dw_ip.GetItemString(dw_ip.GetRow(),"status")

IF IsNull(sCustF)  OR sCustF = "" THEN sCustF = '0'
IF IsNull(sCustT)  OR sCustT = "" THEN	sCustT = 'ZZZZZZ'

IF IsNull(sBnkF) OR sBnkF = "" THEN
	sBnkF = '0'
	sBnkT = 'ZZZZZZ'
END IF

SELECT "KFZ04OM0"."PERSON_NM"
   INTO :sCustFnm
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
			( "KFZ04OM0"."PERSON_CD" = :sCustF) ;
		
SELECT "KFZ04OM0"."PERSON_NM"
   INTO :sbnknmf
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND
			( "KFZ04OM0"."PERSON_CD" = :sBnkF) ;

IF DaysAfter(Date(Left(sDatef,4)+"/"+Mid(sDatef,5,2)+"/"+Right(sDatef,2)),&
				 Date(Left(sDatet,4)+"/"+Mid(sDatet,5,2)+"/"+Right(sDatet,2))) < 0 THEN
	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return -1
END IF

IF sStatus ="" OR IsNull(sStatus) THEN
	sStatus ="%"
	sStatus_nm ="%"
ELSE
  SELECT "REFFPF"."RFNA1" 
	 	INTO :sStatus_nm
  		FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'RS' ) AND
				( "REFFPF"."RFGUB" = :sStatus )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","사용 가능한 어음 상태가 아닙니다.!!!")
		dw_ip.SetFocus()
		Return -1
	END IF 
END IF

Return 1
end function

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN RETURN -1

IF wf_chk_cond() = -1 THEN RETURN -1

IF dw_print.Retrieve(sabu_f,sabu_t,scustf,scustt,sdatef,sdatet,sbnkf,sbnkt,sstatus,sstatus_nm) <=0 THEN
	f_messagechk(14,"")
	Return -1
END IF
dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia03a.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia03a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String scust_min,scust_max,sbnk_min,sbnk_max

//SELECT MIN("KFZ04OM0"."PERSON_CD"),MAX("KFZ04OM0"."PERSON_CD")  
//   INTO :scust_min,:scust_max
//   FROM "KFZ04OM0"  
//   WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) ;
//
//SELECT MIN("KFZ04OM0"."PERSON_CD"),MAX("KFZ04OM0"."PERSON_CD")  
//   INTO :sbnk_min,:sbnk_max
//   FROM "KFZ04OM0"  
//   WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) ;

dw_list.SetTransObject(SQLCA)
			
dw_ip.SetItem(dw_ip.GetRow(),"custf",scust_min)
dw_ip.SetItem(dw_ip.Getrow(),"custt",scust_max)

dw_ip.SetItem(dw_ip.GetRow(),"bankf",sbnk_min)
dw_ip.SetItem(dw_ip.Getrow(),"bankt",sbnk_max)

dw_ip.SetItem(dw_ip.GetRow(),"datef",String(today(),"yyyymm")+'01')
dw_ip.SetItem(dw_ip.GetRow(),"datet",String(today(),"yyyymmdd"))
dw_ip.SetItem(dw_ip.GetRow(),"status",'1')
dw_ip.SetItem(dw_ip.GetRow(),"gubun",'1')

dw_ip.SetColumn("custf")
dw_ip.Setfocus()
end event

type p_xls from w_standard_print`p_xls within w_kfia03a
boolean visible = true
integer x = 3744
integer y = 20
end type

event p_xls::clicked;String	ls_path, ls_file
Int		li_rc 

li_rc = GetFileSaveName('Save As', ls_path, ls_file,  'xls',  'Excel Files (*.xls),*.xls' )

IF li_rc <> 1 THEN Return -1

u_SaveAsExcel luo_excel

li_rc = luo_excel.uf_DwToExcel(dw_print, ls_path)

if li_rc > 0 then
	if luo_excel.uf_RunExcel(ls_path) < 1 then
		MessageBox("Execute Error" , ls_path + " Execute File Error." , Exclamation!)
		return -1
	end if
else
	MessageBox("Error" , "Conversion Error!" , Exclamation!)
	return -1
end if
end event

type p_sort from w_standard_print`p_sort within w_kfia03a
end type

type p_preview from w_standard_print`p_preview within w_kfia03a
end type

type p_exit from w_standard_print`p_exit within w_kfia03a
end type

type p_print from w_standard_print`p_print within w_kfia03a
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia03a
end type







type st_10 from w_standard_print`st_10 within w_kfia03a
end type



type dw_print from w_standard_print`dw_print within w_kfia03a
integer x = 3753
string dataobject = "d_kfia03a_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia03a
integer x = 37
integer y = 8
integer width = 3479
integer height = 280
string dataobject = "d_kfia03a_0"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String snull,sacc1,sacc2,sgubun

SetNull(snull)

sle_msg.text =""

dw_ip.Accepttext()

IF dwo.name ="custf" THEN
	IF data = "" OR IsNull(data) THEN Return
	
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scustfnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"거래처")
//		dw_ip.SetItem(dw_ip.GetRow(),"custf",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(),"custf",scustfnm)
	END IF
END IF

IF dwo.name ="custt" THEN
	IF data = "" OR IsNull(data) THEN Return
	
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scustfnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"거래처")
//		dw_ip.SetItem(dw_ip.GetRow(),"custf",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(),"custt",scustfnm)
	END IF
END IF

IF dwo.name ="bankf" THEN
	IF data = "" OR IsNull(data) THEN 
		sbnkf = '0'
	   sbnkt = 'ZZZZZZ'
   END IF
//	
	SELECT "KFZ04OM0"."PERSON_NM"  
   	INTO :sbnknmf 
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
      	   ( "KFZ04OM0"."PERSON_CD" = :data )   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"은행코드")
//		dw_ip.SetItem(dw_ip.GetRow(),"bankf",snull)
//		Return 1
//	END IF
END IF


IF dwo.name ="datef" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datef" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

IF dwo.name ="gubun" THEN
	dw_ip.SetRedraw(False)
	IF data ='1' THEN
		dw_list.Title ="만기일자별 거래처순"
		dw_list.DataObject ="d_kfia03a_1"
		dw_print.DataObject ="d_kfia03a_1_p"
	ELSEIF data ='2' THEN
		dw_list.Title ="거래처별 만기일자순"
		dw_list.DataObject ="d_kfia03a_2"
		dw_print.DataObject ="d_kfia03a_2_p"
	ELSEIF data ='3' THEN
		dw_list.Title ="만기일자별 지급은행순"
		dw_list.DataObject ="d_kfia03a_4"
		dw_print.DataObject ="d_kfia03a_4_p"
	ELSEIF data ='4' THEN
		dw_list.Title ="지급은행별 만기일자순"
		dw_list.DataObject ="d_kfia03a_3"
		dw_print.DataObject ="d_kfia03a_3_p"
	ELSE
		MessageBox("확 인","출력구분을 입력하시요.!!")
		Return 1
	END IF
	dw_ip.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	dw_print.object.datawindow.print.preview = "yes"
END IF
end event

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() ="custf" THEN
	lstr_custom.code =dw_ip.GetItemString(1,"custf")

	IF IsNull(lstr_custom.code) then
   	lstr_custom.code = ""
	end if

	OpenWithParm(w_kfz04om0_popup1,'1')
	
	IF Not IsNull(lstr_custom.code) THEN
		dw_ip.SetItem(1,"custf",lstr_custom.code)
	END IF
END IF

IF this.GetColumnName() ="custt" THEN
	lstr_custom.code =dw_ip.GetItemString(1,"custt")

	IF IsNull(lstr_custom.code) then
   	lstr_custom.code = ""
	end if

	OpenWithParm(w_kfz04om0_popup1,'1')
	
	IF Not IsNull(lstr_custom.code) THEN
		dw_ip.SetItem(1,"custt",lstr_custom.code)
	END IF
END IF
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia03a
integer x = 46
integer y = 304
integer width = 4567
integer height = 1948
string dataobject = "d_kfia03a_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia03a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 296
integer width = 4585
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type


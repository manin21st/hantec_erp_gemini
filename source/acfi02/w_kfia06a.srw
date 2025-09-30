$PBExportHeader$w_kfia06a.srw
$PBExportComments$받을어음 수탁/할인 명세서 조회 출력
forward
global type w_kfia06a from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia06a
end type
end forward

global type w_kfia06a from w_standard_print
integer x = 0
integer y = 0
string title = "받을어음 수탁/할인 명세서 조회 출력"
rr_1 rr_1
end type
global w_kfia06a w_kfia06a

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj,sbnk,scode,sab_no,sjasa,sacc1,sacc2,acc_name,sbnk_cd,sbnk_nm,ssaupjnm,sStatus

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sSaupj     = dw_ip.GetItemString(dw_ip.Getrow(),"saupj")
sbnk       = dw_ip.GetItemString(dw_ip.Getrow(),"chu_bnk")
scode      = dw_ip.GetItemString(dw_ip.GetRow(),"chu_code")
sStatus    = dw_ip.GetItemString(dw_ip.GetRow(),"status")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

Select rfna1 Into :ssaupjnm
  From reffpf
 Where rfcod = 'AD' and rfgub = :sSaupj;
	 
If sqlca.sqlcode <> 0 Then
	MessageBox("확인", "입력하신 자료에 해당하는 사업장이 없습니다.!!")
	dw_ip.Setcolumn('saupj')
	dw_ip.Setfocus()
	return -1
End If

IF Trim(dw_ip.GetItemString(dw_ip.GetRow(),"chu_ymd")) = '' OR IsNull(Trim(dw_ip.GetItemString(dw_ip.GetRow(),"chu_ymd"))) THEN
	F_Messagechk(1,'[일자]')
	dw_ip.Setcolumn("chu_ymd")
	dw_ip.setfocus()
	Return -1
END IF
dw_print.Modify("saupj.text ='"+ssaupjnm+"'")

IF Trim(scode) ="" OR IsNull(scode) THEN
	scode = '%'
ELSE
	SELECT "KFM04OT0"."AB_NO",     	    "KFM04OT0"."ACC1_CD",
			 "KFM04OT0"."ACC2_CD",			 "KFM04OT0"."BNK_CD"
		INTO :sab_no,							 :sacc1,					
			  :sacc2,                      :sbnk_cd
   	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :scode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","추심계좌코드를 찾을 수 없습니다.!!")
		Return -1
	ELSE
		SELECT "ACC2_NM"							INTO :acc_name
			FROM "KFZ01OM0"
			WHERE "KFZ01OM0"."ACC1_CD" =:sacc1 AND "KFZ01OM0"."ACC2_CD" =:sacc2 ;
					
		SELECT "PERSON_NM"			INTO :sbnk_nm
			FROM "KFZ04OM0"
			WHERE "PERSON_GU" ='2' AND	"PERSON_CD" =:sbnk_cd ;
	END IF
END IF

//자사명//
SELECT "SYSCNFG"."DATANAME"      INTO :sJasa  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '3' )   ;

IF sbnk ="" OR IsNull(sbnk) THEN
	sbnk ="%"
END IF

IF dw_print.Retrieve(Trim(dw_ip.GetItemString(dw_ip.GetRow(),"chu_ymd")),sbnk,sabu_f,sabu_t,sStatus) <=0 THEN
	f_messagechk(14,"")
	dw_ip.SetFocus()
	dw_list.insertrow(0)
	//Return -1
ELSE
	dw_print.Modify("jasa.text   ='"+sjasa+"'")
	dw_print.Modify("name.text   ='"+acc_name+"'")
	dw_print.Modify("sab_no.text ='"+sab_no+"'")
	dw_print.Modify("bnk.text    ='"+sbnk_nm+"'")
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia06a.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia06a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(),'saupj', Gs_Saupj)
dw_ip.SetItem(dw_ip.GetRow(),"chu_ymd",f_today())

IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

dw_ip.SetColumn("saupj")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia06a
end type

type p_exit from w_standard_print`p_exit within w_kfia06a
end type

type p_print from w_standard_print`p_print within w_kfia06a
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia06a
end type







type st_10 from w_standard_print`st_10 within w_kfia06a
end type



type dw_print from w_standard_print`dw_print within w_kfia06a
string dataobject = "d_kfia06a_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia06a
integer x = 14
integer y = 0
integer width = 2318
integer height = 288
string dataobject = "d_kfia06_1"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;
String snull,sbnknm,ssql

SetNull(snull)

IF dwo.name ="status" THEN
	if data = '3' then								/*수탁*/
		this.Modify("chu_ymd_t.text = '수탁일자'")
		this.Modify("chu_bnk_t.text = '수탁은행'")
		this.Modify("chu_code_t.text = '수탁계좌번호'")
		dw_list.dataobject = "d_kfia06a_2"
		dw_print.dataobject = "d_kfia06a_2_p"
	else													/*할인*/
		this.Modify("chu_ymd_t.text = '할인일자'")
		this.Modify("chu_bnk_t.text = '할인은행'")
		this.Modify("chu_code_t.text = '할인계좌번호'")
		dw_list.dataobject = "d_kfia06a_3"
		dw_print.dataobject = "d_kfia06a_3_p"
	end if
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	dw_print.object.datawindow.print.preview = "yes"
END IF

IF dwo.name ="chu_ymd" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"추심일") 
		dw_ip.SetItem(dw_ip.Getrow(),"chu_ymd",snull)
		Return 1
	END IF
END IF

IF dwo.name ="chu_bnk" THEN
	
	IF data ="" OR IsNull(data) THEN 
		data = '%'
	ELSE
		SELECT "KFZ04OM0"."PERSON_NM"  
   		INTO :sbnknm 
    		FROM "KFZ04OM0"  
   		WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND  
      		   ( "KFZ04OM0"."PERSON_CD" = :data )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			f_messagechk(20,"은행")
			dw_ip.SetItem(dw_ip.GetRow(),"chu_bnk",snull)
			Return 1	
		END IF
	END IF
END IF

IF dwo.name ="chu_code" THEN
	if isnull(dwo.name) or dwo.name = "" then 
		dwo.name = '%'
   else
	    SELECT "KFM04OT0"."AB_NAME"  
    	   INTO :ssql  
        	FROM "KFM04OT0"  
   	   WHERE "KFM04OT0"."AB_DPNO" = :data   ;
	    IF SQLCA.SQLCODE <> 0 THEN
//		    f_messagechk(20,"계좌코드")
//		    dw_ip.SetItem(1,"chu_code",snull)
//		    dw_ip.SetColumn("chu_code")
//		    Return 1
		 Else
			 dw_ip.SetItem(1,"chu_code",ssql)
	    END IF
	END IF
END IF
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

IF this.GetColumnName() ="chu_code" THEN
	gs_code =Trim(dw_ip.GetItemString(dw_ip.GetRow(),"chu_code"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM04OT0_POPUP)
	
	IF IsNull(gs_code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"chu_code",gs_code)
	dw_ip.SetItem(dw_ip.GetRow(),"codename",gs_codename)
	
END IF

end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia06a
integer y = 308
integer width = 4567
string title = "받을어음 추심위탁 명세서"
string dataobject = "d_kfia06a_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia06a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4613
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_kglb01h.srw
$PBExportComments$전표 등록 : 고정자산관리 조건
forward
global type w_kglb01h from window
end type
type cb_c from commandbutton within w_kglb01h
end type
type cb_x from commandbutton within w_kglb01h
end type
type p_ok from uo_picture within w_kglb01h
end type
type p_can from uo_picture within w_kglb01h
end type
type rb_3 from radiobutton within w_kglb01h
end type
type dw_1 from u_key_enter within w_kglb01h
end type
type dw_insert from datawindow within w_kglb01h
end type
type rb_2 from radiobutton within w_kglb01h
end type
type rb_1 from radiobutton within w_kglb01h
end type
type gb_1 from groupbox within w_kglb01h
end type
end forward

global type w_kglb01h from window
integer x = 992
integer y = 592
integer width = 1422
integer height = 544
boolean titlebar = true
string title = "고정자산 처리"
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_x cb_x
p_ok p_ok
p_can p_can
rb_3 rb_3
dw_1 dw_1
dw_insert dw_insert
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
end type
global w_kglb01h w_kglb01h

forward prototypes
public function integer wf_control_jasan (string skfcod1, double dkfcod2)
end prototypes

public function integer wf_control_jasan (string skfcod1, double dkfcod2);
Int    iRowCount,iCurRow,dKfnyr,dKfjyr,iCount
String sProcGbn,sChgGbn
String sKfsacod,sKfjog,sKfname,sKfmdpt,sKfdecp,sKfdegb,sKfsize,sKfmekr,sKfgubun,sKfhalf,&
       sKfgbn,sMandept,sGubun1,sEuroiEmpno,sChaNo,sPumNo,sYongdo,sJejo,sJunap,sGumeGb,&
		 sGaro,sSero,sNopi,sGwanNo,sSu_type,sGyeGb,sGwan_hwak,sJakupjang,sSayongDept,sIngyeHwak,&
		 sInsuHwak,sDungHwak,sGuipDate,sGongjeong,sCavity,sAsTel,sAsDam, sManualGb,sDoGb,sGumeyo,&
		 sGumepum,sGyenjuk,sGyeyak,sSegum,sGeorae,sBaechi,sDomyun,sJese,sSuip,sBul,sWhoiu,sDunggi,&
		 sBoheom,sGwancheong,sImde,sJehwal,sJegeo,sJigub,sGita,sGitasahang,sEuroiDeptno,sJakupjangNm

IF rb_2.Checked = True then							/*자본적지출*/
	sProcGbn = '2';			sChgGbn = 'D';
ELSEIF rb_3.Checked = True THEN						/*자산이동*/
	sProcGbn = '3';			SetNull(sChgGbn);
END IF

iRowCount = dw_insert.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																	lstr_jpra.bjunno,lstr_jpra.sortno,sProcGbn) 

IF iRowCount > 0 THEN
	dw_insert.DeleteRow(0)
	IF dw_insert.Update() <> 1 THEN
		F_MessageChk(12,'')
		Return -1
	END IF	
END IF

iCurRow = dw_insert.InsertRow(0)

dw_insert.SetItem(iCurRow,"saupj",    lstr_jpra.saupjang)
dw_insert.SetItem(iCurRow,"bal_date", lstr_jpra.baldate)
dw_insert.SetItem(iCurRow,"upmu_gu",  lstr_jpra.upmugu)
dw_insert.SetItem(iCurRow,"bjun_no",  lstr_jpra.bjunno)
dw_insert.SetItem(iCurRow,"lin_no",   lstr_jpra.sortno)
	
dw_insert.SetItem(iCurRow,"kfcod1",   sKfCod1)
dw_insert.SetItem(iCurRow,"kfcod2",   dKfCod2)

dw_insert.SetItem(iCurRow,"kfchgb",   sChgGbn)

dw_insert.SetItem(iCurRow,"kfaqdt",   lstr_jpra.baldate)	
dw_insert.setItem(iCurRow,"kfamt",    lstr_jpra.money)

dw_insert.SetItem(iCurRow,"procgbn",  sProcGbn)

//개수인 경우 고정자산 취득완료보고서를 인쇄하기 위한 처리
Select Count(*)
  Into :iCount
  From kfz12oth
 Where kfcod1 = :sKfCod1
   And kfcod2 = :dKfCod2
	And procgbn = '1';

IF iCount > 0 THEN
	
	Select kfsacod,    kfjog,      kfname,     kfnyr,      kfjyr,      kfmdpt,       kfdecp,        kfdegb,
	       kfsize,     kfmekr,     kfgubun,    kfhalf,     kfgbn,      mandept,      gubun1,        euroi_empno,
			 cha_no,     pum_no,     yongdo,     jejo,       junap,      gume_gb,      garo,          sero,
			 nopi,       gwan_no,    su_type,    gye_gb,     gwan_hwak,  jakupjang,    sayong_dept,   ingye_hwak,
			 insu_hwak,  dung_hwak,  guip_date,  gongjeong,  cavity,     as_tel,       as_dam,        manual_gb,
			 do_gb,      gumeyo,     gumepum,    gyenjuk,    gyeyak,     segum,        georae,        baechi,
			 domyun,     jese,       suip,bul,   whoiu,      dunggi,     boheom,       gwancheong,    imde,
			 jehwal,     jegeo,      jigub,      gita,       gitasahang, euroi_deptno, jakupjang_nm
	  Into :sKfsacod,  :sKfjog,    :sKfname,   :dKfnyr,    :dKfjyr,    :sKfmdpt,     :sKfdecp,      :sKfdegb,
	       :sKfsize,   :sKfmekr,   :sKfgubun,  :sKfhalf,   :sKfgbn,    :sMandept,    :sGubun1,      :sEuroiEmpno,
			 :sChaNo,    :sPumNo,    :sYongdo,   :sJejo,     :sJunap,    :sGumeGb,     :sGaro,        :sSero,
			 :sNopi,     :sGwanNo,   :sSu_type,  :sGyeGb,    :sGwan_hwak,:sJakupjang,  :sSayongDept,  :sIngyeHwak,
			 :sInsuHwak, :sDungHwak, :sGuipDate, :sGongjeong,:sCavity,   :sAsTel,      :sAsDam,       :sManualGb,
			 :sDoGb,     :sGumeyo,   :sGumepum,  :sGyenjuk,  :sGyeyak,   :sSegum,      :sGeorae,      :sBaechi,
			 :sDomyun,   :sJese,     :sSuip,     :sBul,      :sWhoiu,    :sDunggi,     :sBoheom,      :sGwancheong,
			 :sImde,     :sJehwal,   :sJegeo,    :sJigub,    :sGita,     :sGitasahang, :sEuroiDeptno,:sJakupjangNm
	  From kfz12oth
	 Where kfcod1 = :sKfCod1
	   And kfcod2 = :dKfCod2
		And procgbn = '1';
	
	dw_insert.SetItem(iCurRow,"kfsacod",sKfsacod)
	dw_insert.SetItem(iCurRow,"kfjog",sKfjog)
	dw_insert.SetItem(iCurRow,"kfname",sKfname)
	dw_insert.SetItem(iCurRow,"kfnyr",dKfnyr)
	dw_insert.SetItem(iCurRow,"kfjyr",dKfjyr)
	dw_insert.SetItem(iCurRow,"kfmdpt",sKfmdpt)
	dw_insert.SetItem(iCurRow,"kfdecp",sKfdecp)
	dw_insert.SetItem(iCurRow,"kfdegb",sKfdegb)
	dw_insert.SetItem(iCurRow,"kfsize",sKfsize)
	dw_insert.SetItem(iCurRow,"kfmekr",sKfmekr)
	dw_insert.SetItem(iCurRow,"kfgubun",sKfgubun)
	dw_insert.SetItem(iCurRow,"kfhalf",sKfhalf)
	dw_insert.SetItem(iCurRow,"kfgbn",sKfgbn)
	dw_insert.SetItem(iCurRow,"mandept",sMandept)
	dw_insert.SetItem(iCurRow,"gubun1",sGubun1)
	dw_insert.SetItem(iCurRow,"euroi_empno",sEuroiEmpno)
	dw_insert.SetItem(iCurRow,"cha_no",sChaNo)
	dw_insert.SetItem(iCurRow,"pum_no",sPumNo)
	dw_insert.SetItem(iCurRow,"yongdo",sYongdo)
	dw_insert.SetItem(iCurRow,"jejo",sJejo)
	dw_insert.SetItem(iCurRow,"junap",sJunap)
	dw_insert.SetItem(iCurRow,"gume_gb",sGumeGb)
	dw_insert.SetItem(iCurRow,"garo",sGaro)
	dw_insert.SetItem(iCurRow,"sero",sSero)
	dw_insert.SetItem(iCurRow,"nopi",sNopi)
	dw_insert.SetItem(iCurRow,"gwan_no",sGwanNo)
	dw_insert.SetItem(iCurRow,"su_type",sSu_type)
	dw_insert.SetItem(iCurRow,"gye_gb",sGyeGb)
	dw_insert.SetItem(iCurRow,"gwan_hwak",sGwan_hwak)
	dw_insert.SetItem(iCurRow,"jakupjang",sJakupjang)
	dw_insert.SetItem(iCurRow,"sayong_dept",sSayongDept)
	dw_insert.SetItem(iCurRow,"ingye_hwak",sIngyeHwak)
	dw_insert.SetItem(iCurRow,"insu_hwak",sInsuHwak)
	dw_insert.SetItem(iCurRow,"dung_hwak",sDungHwak)
	dw_insert.SetItem(iCurRow,"guip_date",sGuipDate)
	dw_insert.SetItem(iCurRow,"gongjeong",sGongjeong)
	dw_insert.SetItem(iCurRow,"cavity",sCavity)
	dw_insert.SetItem(iCurRow,"as_tel",sAsTel)
	dw_insert.SetItem(iCurRow,"as_dam",sAsDam)
	dw_insert.SetItem(iCurRow,"manual_gb",sManualGb)
	dw_insert.SetItem(iCurRow,"do_gb",sDoGb)
	dw_insert.SetItem(iCurRow,"gumeyo",sGumeyo)
	dw_insert.SetItem(iCurRow,"gumepum",sGumepum)
	dw_insert.SetItem(iCurRow,"gyenjuk",sGyenjuk)
	dw_insert.SetItem(iCurRow,"gyeyak",sGyeyak)
	dw_insert.SetItem(iCurRow,"segum",sSegum)
	dw_insert.SetItem(iCurRow,"georae",sGeorae)
	dw_insert.SetItem(iCurRow,"baechi",sBaechi)
	dw_insert.SetItem(iCurRow,"domyun",sDomyun)
	dw_insert.SetItem(iCurRow,"jese",sJese)
	dw_insert.SetItem(iCurRow,"suip",sSuip)
	dw_insert.SetItem(iCurRow,"bul",sBul)
	dw_insert.SetItem(iCurRow,"whoiu",sWhoiu)
	dw_insert.SetItem(iCurRow,"dunggi",sDunggi)
	dw_insert.SetItem(iCurRow,"boheom",sBoheom)
	dw_insert.SetItem(iCurRow,"gwancheong",sGwancheong)
	dw_insert.SetItem(iCurRow,"imde",sImde)
	dw_insert.SetItem(iCurRow,"jehwal",sJehwal)
	dw_insert.SetItem(iCurRow,"jegeo",sJegeo)
	dw_insert.SetItem(iCurRow,"jigub",sJigub)
	dw_insert.SetItem(iCurRow,"gita",sGita)
	dw_insert.SetItem(iCurRow,"gitasahang",sGitasahang)
	dw_insert.SetItem(iCurRow,"euroi_deptno",sEuroiDeptno)
	dw_insert.SetItem(iCurRow,"jakupjang_nm",sJakupjangNm)
	
END IF

if rb_3.Checked = True then
	dw_insert.SetItem(iCurRow,"kfsacod",dw_1.GetItemString(1,"kfsacod"))	
end if

Return 1
end function

on w_kglb01h.create
this.cb_c=create cb_c
this.cb_x=create cb_x
this.p_ok=create p_ok
this.p_can=create p_can
this.rb_3=create rb_3
this.dw_1=create dw_1
this.dw_insert=create dw_insert
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
this.Control[]={this.cb_c,&
this.cb_x,&
this.p_ok,&
this.p_can,&
this.rb_3,&
this.dw_1,&
this.dw_insert,&
this.rb_2,&
this.rb_1,&
this.gb_1}
end on

on w_kglb01h.destroy
destroy(this.cb_c)
destroy(this.cb_x)
destroy(this.p_ok)
destroy(this.p_can)
destroy(this.rb_3)
destroy(this.dw_1)
destroy(this.dw_insert)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
end on

event open;
String  sProcGbn,sKfCod1,sSaupj
Double  dKfCod2

F_Window_Center_Response(This)

dw_1.SetTransObject(Sqlca)
dw_1.Reset()
dw_1.InsertRow(0)

dw_insert.SetTransObject(Sqlca)
dw_insert.Reset()

rb_1.Enabled = True

SELECT "KFCOD1",			"KFCOD2",		"PROCGBN",		"KFSACOD"	   
	INTO :sKfCod1,			:dKfcod2,		:sProcGbn,		:sSaupj  
	FROM "KFZ12OTH"  
   WHERE ( "KFZ12OTH"."SAUPJ"    = :lstr_jpra.saupjang ) AND  
         ( "KFZ12OTH"."BAL_DATE" = :lstr_jpra.baldate  ) AND  
         ( "KFZ12OTH"."UPMU_GU"  = :lstr_jpra.upmugu ) AND  
         ( "KFZ12OTH"."BJUN_NO"  = :lstr_jpra.bjunno ) AND  
         ( "KFZ12OTH"."LIN_NO"   = :lstr_jpra.sortno );
IF SQLCA.SQLCODE = 0 THEN
	IF sProcGbn = '1' THEN					/*신규취득*/
		rb_1.Checked = True
	
		dw_1.SetItem(1,"flag",'I')
		dw_1.Enabled = False
	
		rb_2.Checked = False
		rb_2.Enabled = False
		rb_3.Checked = False
		rb_3.Enabled = False
	ELSEIF sProcGbn = '2' THEN				/*자본적 지출*/
		rb_1.Checked = False
		rb_1.Enabled = False

		rb_2.Checked = True
		
		rb_3.Checked = False
		rb_3.Enabled = False
		
		dw_1.SetItem(1,"flag",'M')
		
		dw_1.SetItem(1,"kfcod1",sKfcod1)
		dw_1.SetItem(1,"kfcod2",dKfcod2)
	ELSE
		rb_1.Checked = False
		rb_1.Enabled = False

		rb_2.Checked = False
		rb_2.Enabled = False

		rb_3.Checked = True
		
		dw_1.SetItem(1,"flag",'E')
		
		dw_1.SetItem(1,"kfcod1", sKfcod1)
		dw_1.SetItem(1,"kfcod2", dKfcod2)
		dw_1.SetItem(1,"kfsacod",sSaupj)
	END IF
ELSE
	rb_1.Checked = True
	
	dw_1.SetItem(1,"flag",'I')
	dw_1.Enabled = False
END IF




end event

type cb_c from commandbutton within w_kglb01h
integer x = 1111
integer y = 736
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type cb_x from commandbutton within w_kglb01h
integer x = 1111
integer y = 828
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Z)"
end type

event clicked;p_ok.TriggerEvent(Clicked!)
end event

type p_ok from uo_picture within w_kglb01h
integer x = 1189
integer y = 32
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;String sRtnValue

IF rb_1.Checked = True THEN
	Open(w_kglb01i)

	sRtnValue = Message.StringParm
ELSEIF rb_2.checked = True OR rb_3.Checked = True THEN
	String sKfCod1
	Double dKfCod2
	
	dw_1.AcceptText()
	sKfCod1 = dw_1.GetItemString(1,"kfcod1")
	dKfCod2 = dw_1.GetItemNumber(1,"kfcod2")
	
	IF sKfcod1 = "" OR IsNull(sKfCod1) THEN
		F_MessageChk(1,'[자산번호]')
		dw_1.SetColumn("kfcod1")
		dw_1.SetFocus()
		Return
	END IF
	IF dKfcod2 = 0 OR IsNull(dKfCod2) THEN
		F_MessageChk(1,'[자산번호]')
		dw_1.SetColumn("kfcod2")
		dw_1.SetFocus()
		Return
	END IF
	
	IF Wf_Control_Jasan(sKfcod1,dKfcod2) = -1 THEN 
		F_MessageChk(13,'[고정자산]')
		dw_1.SetColumn("kfcod2")
		dw_1.SetFocus()
		Return 
	ELSE
		IF dw_insert.Update() <> 1 THEN
			F_messageChk(13,'')
			Return
		END IF
	END IF	
	
	sRtnValue = '1'
END IF
CloseWithReturn(Parent, sRtnValue)	


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

type p_can from uo_picture within w_kglb01h
integer x = 1015
integer y = 32
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;CloseWithReturn(parent,'0')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type rb_3 from radiobutton within w_kglb01h
integer x = 521
integer y = 140
integer width = 402
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "자산이동"
end type

event clicked;dw_1.SetItem(1,"flag",'E')

dw_1.Enabled = True

dw_1.SetFocus()
end event

type dw_1 from u_key_enter within w_kglb01h
event ue_key pbm_dwnkey
integer x = 18
integer y = 256
integer width = 1381
integer height = 156
integer taborder = 10
string dataobject = "dw_kglb01h_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;String  sKfCod1,snull,sSaupj
Double  dKfcod2

SetNull(sNull)

IF this.GetColumnName() = "kfcod1" THEN
	sKfCod1 = this.GetText()
	IF sKfCod1 = "" OR IsNull(sKfCod1) THEN Return
	
	If IsNull(F_Get_Refferance('F1',sKfCod1)) THEN
		F_MessageChk(20,'[자산번호]')
		this.SetItem(this.GetRow(),"kfcod1",snull)
		Return 1
	END IF
	
	dKfCod2 = this.GetItemNumber(1,"kfcod2")
	IF dKfcod2 = 0 OR Isnull(dKfcod2) THEN Return
	
	select kfCod2, kfsacod 	into :dKfCod2,	:sSaupj
		from kfa02om0
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[자산번호]')
		this.SetItem(this.GetRow(),"kfcod1",snull)
		this.SetItem(this.GetRow(),"kfcod2",SetNull(dKfCod2))
		Return 1
	end if
	
	if rb_3.Checked = True then
		if lstr_jpra.saupjang = sSaupj then	
			F_MessageChk(20,'[자산사업장 = 전표사업장]')
			this.SetItem(this.GetRow(),"kfcod1",snull)
			this.SetItem(this.GetRow(),"kfcod2",SetNull(dKfCod2))
			Return 1
		end if
	end if
	this.SetItem(this.GetRow(),"kfsacod",sSaupj) 
END IF

IF this.GetColumnName() = "kfcod2" THEN
	dKfCod2 = Double(this.GetText())
	IF IsNull(dKfCod2) OR dKfCod2 = 0 THEN Return
	
	sKfCod1 = this.GetItemString(1,"kfcod1")
	IF sKfcod1 = "" OR Isnull(sKfcod1) THEN Return

	select kfCod2, kfsacod 	into :dKfCod2,	:sSaupj
		from kfa02om0
		where kfcod1 = :sKfCod1 and kfcod2 = :dKfCod2;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[자산번호]')
		this.SetItem(this.GetRow(),"kfcod1",snull)
		this.SetItem(this.GetRow(),"kfcod2",SetNull(dKfCod2))
		Return 1
	end if
	if rb_3.Checked = True then
		if lstr_jpra.saupjang = sSaupj then	
			F_MessageChk(20,'[자산사업장 = 전표사업장]')
			this.SetItem(this.GetRow(),"kfcod1",snull)
			this.SetItem(this.GetRow(),"kfcod2",SetNull(dKfCod2))
			Return 1
		end if
	end if
	this.SetItem(this.GetRow(),"kfsacod",sSaupj) 
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;

IF this.GetColumnName() ="kfcod2" THEN 	
	gs_code = dw_1.GetItemString(1, "kfcod1")

	IF Isnull(gs_code) then gs_code = ""

	open(w_kfaa02b)

	IF IsNull(Double(gs_codename)) THEN Return
	
	this.SetItem(1,"kfcod1",Gs_Code)
	this.SetItem(1,"kfcod2",Double(gs_codename))
	
	this.TriggerEvent(ItemChanged!)
END IF
end event

type dw_insert from datawindow within w_kglb01h
boolean visible = false
integer x = 46
integer y = 680
integer width = 1033
integer height = 580
boolean titlebar = true
string title = "고정자산 자본적 지출"
string dataobject = "dw_kglb01h_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type rb_2 from radiobutton within w_kglb01h
integer x = 73
integer y = 140
integer width = 402
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "자본적 지출"
end type

event clicked;dw_1.SetItem(1,"flag",'M')

dw_1.Enabled = True

dw_1.SetFocus()
end event

type rb_1 from radiobutton within w_kglb01h
integer x = 73
integer y = 64
integer width = 402
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "신규 취득"
boolean checked = true
end type

event clicked;
dw_1.SetItem(1,"flag",'I')

dw_1.Enabled = False


end event

type gb_1 from groupbox within w_kglb01h
integer x = 27
integer y = 8
integer width = 951
integer height = 236
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "선택"
end type


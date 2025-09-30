$PBExportHeader$w_sal_02540.srw
$PBExportComments$���� ���� ��Ȳ - ��ǰ��
forward
global type w_sal_02540 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02540
end type
type pb_2 from u_pb_cal within w_sal_02540
end type
type rr_2 from roundrectangle within w_sal_02540
end type
type rr_1 from roundrectangle within w_sal_02540
end type
end forward

global type w_sal_02540 from w_standard_print
string title = "���� ���� ��Ȳ - ��ǰ��"
boolean maxbox = true
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
rr_1 rr_1
end type
global w_sal_02540 w_sal_02540

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDepotNo, sIttyp, sItcls, sItnbr, tx_name, sPspec
String sFRom, sTo,ls_steamcd,ls_sarea,ls_sugugb,ls_pangb,ssaupj ,ls_emp_id

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sDepotNo    = Trim(dw_ip.GetItemString(1,"depot_no"))
sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
sItcls      = Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
sPspec      = Trim(dw_ip.GetItemString(1,"ispec"))
ls_steamcd    = Trim(dw_ip.GetItemString(1,"steamcd"))
ls_sarea    = Trim(dw_ip.GetItemString(1,"sarea"))
ls_sugugb   = Trim(dw_ip.GetItemString(1,"sugugb"))
ls_pangb    = Trim(dw_ip.GetItemString(1,"pangb"))
ssaupj      = Trim(dw_ip.getitemstring(1,"saupj"))
ls_emp_id   = Trim(dw_ip.getitemstring(1,'emp_id'))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[���ֱⰣ]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[���ֱⰣ]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[�ΰ������]')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF sDepotNo = "" OR IsNull(sDepotNo) THEN
	f_message_chk(30,'[â��]')
	dw_ip.SetColumn("depot_no")
	dw_ip.SetFocus()
	Return -1
END IF

If Isnull(sIttyp) Then sIttyp = ''
If Isnull(sItcls) Then sItcls = ''
If Isnull(sItnbr) Then sItnbr = ''
If Isnull(sPspec) or sPspec = '' Then sPspec = ''
If Isnull(ls_steamcd) or ls_steamcd = '' Then ls_steamcd = '%'
If Isnull(ls_sarea) or ls_sarea = '' Then ls_sarea = '%'
If Isnull(ls_sugugb) or ls_sugugb = '' Then ls_sugugb = '%'
If Isnull(ls_pangb) or ls_pangb = '' Then ls_pangb = '%'
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id ='%'

//IF dw_list.Retrieve(gs_sabu, sDepotNo,sIttyp+'%',sItcls+'%',sItnbr+'%', sPspec+'%',sFrom, sTo,ls_steamcd,ls_sarea,ls_sugugb,ls_pangb,ssaupj ,ls_emp_id) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('depot_no')
//	dw_ip.SetFocus()
//	Return -1
//END IF

IF dw_print.Retrieve(gs_sabu, sDepotNo,sIttyp+'%',sItcls+'%',sItnbr+'%', sPspec+'%',sFrom, sTo,ls_steamcd,ls_sarea,ls_sugugb,ls_pangb,ssaupj ,ls_emp_id) <=0 THEN
	f_message_chk(50,'')
	dw_list.Reset()
   dw_ip.setcolumn('depot_no')
	dw_ip.SetFocus()	
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")
dw_list.Modify("tx_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_itcls.text = '"+tx_name+"'")
dw_list.Modify("tx_itcls.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_itdsc.text = '"+tx_name+"'")
dw_list.Modify("tx_itdsc.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steamcd) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_steamcd.text = '"+tx_name+"'")
dw_list.Modify("tx_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")
dw_list.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sugugb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_sugugb.text = '"+tx_name+"'")
dw_list.Modify("tx_sugugb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_pangb.text = '"+tx_name+"'")
dw_list.Modify("tx_pangb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")
dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02540.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_sal_02540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User�� ���ұ��� Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steamcd.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
	dw_ip.Modify("steamcd.background.color = 80859087")
End If

dw_ip.SetItem(1, 'sarea', sarea)
dw_ip.SetItem(1, 'steamcd', steam)
dw_ip.SetItem(1, 'saupj', saupj)
	

/* ����� ���� */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//������
f_child_saupj(dw_ip, 'steamcd', '%') 

//���� ����
f_child_saupj(dw_ip, 'sarea', '%') 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.Setfocus()
sle_msg.text = "��¹� - ����ũ�� : A4, ��¹��� : ���ι���"
end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //ȸ���� ���
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*����*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*���� üũ- ���� ����*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*�ڱ�*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*���� üũ- ���� ����*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_02540
string picturename = "C:\erpman\image\�̸�����_up.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_02540
end type

type p_print from w_standard_print`p_print within w_sal_02540
string picturename = "C:\erpman\image\�μ�_up.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02540
end type











type dw_print from w_standard_print`dw_print within w_sal_02540
boolean visible = true
integer x = 55
integer y = 440
integer width = 4539
integer height = 1868
string dataobject = "d_sal_02540_1_p"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02540
integer x = 46
integer y = 40
integer width = 3826
integer height = 336
string dataobject = "d_sal_025401"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;call super::itemchanged;String  sNull, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sDateFrom,sJijil, sIspeccode
String  sItemCls, sItemGbn, sItemClsName,sIoCustArea,sdept,	ls_saupj
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	Case "sdatef","sdatet"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[���ֱⰣ]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* ǰ�񱸺� */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	/* ǰ��з� */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* ǰ��� */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 this.TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 this.SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* ǰ�� */
	  Case	"itnbr" 
		 sItnbr = Trim(this.GetText())
		 IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		
		 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM"
			INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName
			FROM "ITEMAS","ITNCT"
		  WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				  "ITEMAS"."ITNBR" = :sItnbr ;
	
		 IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		 END IF
		
		 SetItem(nRow,"ittyp", sIttyp)
		 SetItem(nRow,"itdsc", sItdsc)
		 SetItem(nRow,"ispec", sIspec)
		 SetItem(nRow,"itcls", sItcls)
		 SetItem(nRow,"itclsnm", sItemClsName)
	/* ǰ�� */
	 Case "itdsc"
		 sItdsc = trim(this.GetText())	
		 IF sItdsc ="" OR IsNull(sItdsc) THEN
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
			 SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		 
		/* ǰ������ ǰ��ã�� */
		f_get_name4('ǰ��', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		 If IsNull(sItnbr ) Then
			 Return 1
		 ElseIf sItnbr <> '' Then
			 SetItem(nRow,"itnbr",sItnbr)
			 SetColumn("itnbr")
			 SetFocus()
			 TriggerEvent(ItemChanged!)
			 Return 1
		 ELSE
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
			 SetItem(nRow,'ispec',sNull)
			 SetColumn("itdsc")
			 Return 1
		End If	
	/* �԰� */
	Case "ispec"
		sIspec = trim(this.GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
	
	   /* �԰����� ǰ��ã�� */
	   f_get_name4('�԰�', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("ispec")
			Return 1
	  End If
	/* ���౸�� */
	Case 'prtgb'
		dw_list.SetRedraw(False)
		If Trim(GetText()) = '0' Then /* ��� */
		 dw_list.DataObject = 'd_sal_02540_4_p'
		 dw_print.DataObject = 'd_sal_02540_4_p'
		Else                 /* �� */
		 dw_list.DataObject = 'd_sal_02540_1_p'
		 dw_print.DataObject = 'd_sal_02540_1_p'
		End If
		dw_list.SetTransObject(sqlca)
		dw_print.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
// ������ 
  Case "steamcd"
		SetItem(1,'sarea',sNull)
//		SetItem(1,"custcode",sNull)
//		SetItem(1,"custname",sNull)
	/* ���ұ��� */
	Case "sarea"
//		SetItem(1,"custcode",sNull)
//		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'steamcd',sDept)
	
	case 'saupj ' 
		STRING ls_return, ls_sarea , ls_steam  
		//�ŷ�ó
		ls_saupj = gettext() 
//		//���� ����
//		f_child_saupj(dw_ip, 'sarea', ls_saupj)
//		ls_sarea = dw_ip.object.sarea[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'sarea', '')
//		End if 
//		//������
//		f_child_saupj(dw_ip, 'steam', ls_saupj) 
//		ls_steam = dw_ip.object.steam[1] 
//		ls_return = f_saupj_chk_t('2' , ls_steam ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'steam', '')
//		End if 
		
END Choose

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
  Case "itcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
/* ---------------------------------------- */
  Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)
END Choose
end event

event dw_ip::ue_key;call super::ue_key;string sCol

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	
end event

type dw_list from w_standard_print`dw_list within w_sal_02540
boolean visible = false
integer x = 55
integer y = 440
integer width = 4544
integer height = 1880
string dataobject = "d_sal_02540_4"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02540
integer x = 901
integer y = 56
integer width = 82
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('sdatef')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02540
integer x = 1367
integer y = 56
integer width = 82
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('sdatet')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_2 from roundrectangle within w_sal_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 424
integer width = 4576
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_1 from roundrectangle within w_sal_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 36
integer width = 3858
integer height = 360
integer cornerheight = 40
integer cornerwidth = 46
end type


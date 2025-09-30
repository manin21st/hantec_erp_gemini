$PBExportHeader$w_sal_06540.srw
$PBExportComments$ ===> Buyer�� ���� üũ����Ʈ
forward
global type w_sal_06540 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06540
end type
type pb_2 from u_pb_cal within w_sal_06540
end type
type rr_1 from roundrectangle within w_sal_06540
end type
end forward

global type w_sal_06540 from w_standard_print
string title = "Buyer�� ���� üũ ����Ʈ"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_06540 w_sal_06540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubun, sFrom, sTo, sOldSql, sWhere_Syntex, sNewSql, sV, sV_Name, sS, sS_Name , ls_saupj ,tx_name

If dw_ip.AcceptText() <> 1 Then Return 1

ls_saupj = Trim(dw_ip.getitemstring(1,'saupj'))
If ls_saupj = '' Or IsNull(ls_saupj) Then ls_saupj = '%'

sGubun = dw_ip.GetItemString(1,'gubun')
sFrom = Trim(dw_ip.GetItemString(1,'d_from'))
if	(sFrom = '') or isNull(sFrom) then
	f_Message_Chk(35, '[��������]')
	dw_ip.setcolumn('d_from')
	dw_ip.setfocus()
	Return -1
end if

sTo = Trim(dw_ip.GetItemString(1,'d_to'))
if	(sTo = '') or isNull(sTo) then
	f_Message_Chk(35, '[��������]')
	dw_ip.setcolumn('d_to')
	dw_ip.setfocus()
	Return -1
end if

if	( sFrom > sTo ) then
	f_message_Chk(200, '[���� �� ������ CHECK]')

	dw_ip.setcolumn('d_to')
	dw_ip.setfocus()
	Return -1
END IF

// ���ұ��� ����
sS = Trim(dw_ip.GetItemString(1,'sarea'))
if isNull(sS) or (sS = '') then
	sS = ''
	sS_Name = '��  ü'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sS;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if
sS = sS + '%'

// �ŷ�ó ����
sV = Trim(dw_ip.GetItemString(1,'cvcod'))
if isNull(sV) or (sV = '') then
	sV = '%'
	sV_Name = '��  ü'
else
	sV = sV + '%'
	sV_Name = Trim(dw_ip.GetItemString(1,'cvnas2'))
end if

sOldSql = " Select B.cvnas2, A.cv_order_no, decode(d.ispec_code,null,d.jijil, d.jijil||'-'||d.ispec_code) as jijil, D.ispec as ispec , A.itnbr, D.itdsc, A.order_spec, A.order_qty, " + &
          "        A.ord_ok_date, A.dicision_napgi, A.cust_napgi, A.out_date, " + &
          "        A.out_qty, nvl(A.order_qty,0) - nvl(A.out_qty,0) as jan_qty, A.pino, E.hold_date,E.hold_qty " + &
          " From   sorder A, vndmst B, sarea C, itemas D, holdstock E " + &
          " Where  A.cvcod = B.cvcod and B.sarea = C.sarea(+) and " + &
			 "        A.sabu = E.sabu(+) and A.order_no = E.order_no(+) and " + &
			 "        nvl(E.out_chk,0) <> '3' and " + &
          "        A.sabu = '" + gs_sabu + "' and A.suju_sts not in ( '3','4') and " + &
          "        A.oversea_gu = '" + '2' + "' and A.itnbr = D.itnbr and " 

/* ���� ����Ÿ */
if sGubun = '2' then
	sWhere_Syntex = " A.sabu = '" + gs_sabu + "' and " + &
			          " A.ord_ok_date between '" + sFrom + "' and '" + sTo + "' and " + &
                   " A.cvcod like '" + sV + "' and B.sarea like '" + sS + "' and " + &
						 " A.saupj like '" + ls_saupj + "' and " + &
						 " nvl(A.out_qty,0) > 0 " + &
						 " Order By B.cvnas2, A.cv_order_no "
/* �̼��� ����Ÿ */
elseif sGubun = '3' then
	sWhere_Syntex = " A.sabu = '" + gs_sabu + "' and " + &
			          " A.ord_ok_date between '" + sFrom + "' and '" + sTo + "' and " + &
                   " A.cvcod like '" + sV + "' and B.sarea like '" + sS + "' and " + &
						 " A.saupj like '" + ls_saupj + "' and " + &
						 " nvl(A.order_qty,0) - nvl(A.out_qty,0) > 0 " + &
						 " Order By B.cvnas2, A.cv_order_no "						 
else
/* ��ü */
	sWhere_Syntex = " A.sabu = '" + gs_sabu + "' and " + &
			          " A.ord_ok_date between '" + sFrom + "' and '" + sTo + "' and " + &
                   " A.cvcod like '" + sV + "' and B.sarea like '" + sS + "' and" + &
						 " A.saupj like '" + ls_saupj + "'" + &
						 " Order By B.cvnas2, A.cv_order_no "						 
end if

sNewSql = sOldSql + sWhere_Syntex
dw_list.SetSqlSelect(sNewSql)

//if sGubun = '1' then
//	dw_list.object.r_gubun.Text = '��  ü'
//elseif sGubun = '2' then
//	dw_list.object.r_gubun.Text = '��  ��'
//else
//	dw_list.object.r_gubun.Text = '�̼���'
//end if

//dw_list.object.r_fromto.Text = Left(sFrom,4)+'.'+Mid(sFrom,5,2)+'.'+Right(sFrom,2) + ' - ' + &
//                               Left(sTo,4)+'.'+Mid(sTo,5,2)+'.'+Right(sTo,2)
//dw_list.object.r_sarea.Text = sS_Name
//dw_list.object.r_cvcod.Text = sV_Name

if dw_print.Retrieve() < 1 then
	f_message_Chk(300, '[������� CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	return -1
end if

  dw_print.sharedata(dw_list)
  
tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

return 1
end function

on w_sal_06540.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_06540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;String sDatef, sDatet

/* User�� ���ұ��� Setting */
String sarea, steam, saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If
//dw_ip.SetItem(1, "saupj", saupj)
//dw_ip.SetItem(1, "sarea", sarea)

select to_char(sysdate,'yyyymmdd'),to_char(sysdate-7,'yyyymmdd')
  into :sDateT, :sDateF
  from dual;

dw_ip.SetItem(1,'d_from',left(sDatef,6) + '01')
dw_ip.SetItem(1,'d_to',sDatet)

/* ����� ���� */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

//���� ����
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

w_mdi_frame.sle_msg.text = "��������� �Է��ϰ� ��ȸ������ ��������"

end event

event open;call super::open;Integer  li_idx

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

type p_preview from w_standard_print`p_preview within w_sal_06540
end type

type p_exit from w_standard_print`p_exit within w_sal_06540
end type

type p_print from w_standard_print`p_print within w_sal_06540
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06540
end type







type st_10 from w_standard_print`st_10 within w_sal_06540
end type



type dw_print from w_standard_print`dw_print within w_sal_06540
string dataobject = "d_sal_06540_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06540
integer y = 20
integer width = 2757
integer height = 284
string dataobject = "d_sal_06540_01"
end type

event dw_ip::itemchanged;String  sNull
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1, ls_saupj

SetNull(sNull)

Choose Case GetColumnName()
   // �������� ��ȿ�� Check
	Case "d_from"  
		if f_DateChk(Trim(getText())) = -1 then
			f_Message_Chk(35, '[��������]')
			SetItem(1, "d_from", sNull)
			return 1
		end if
		
	// ������ ��ȿ�� Check
   Case "d_to"
		if f_DateChk(Trim(getText())) = -1 then
			SetItem(1, "d_to", sNull)
			f_Message_Chk(35, '[��������]')
			return 1
		end if
		if Long(GetItemString(1,'d_from')) > Long(GetText()) then
       	f_message_Chk(200, '[���� �� ������ CHECK]')
         SetItem(1, "d_to", sNull)
      	setcolumn('d_to')
       	setfocus()			
			return 1
		end if
	Case "sarea"
		SetItem(1, "cvcod", sNull)
		SetItem(1, "cvnas2", sNull)
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod)
				SetItem(1,"cvnas2",		scvnas)
			else
				Messagebox('Ȯ��', scvnas + '[ ' + sCvcod +  ' ]�� ��ϵ� ����� �ٸ��ϴ�. ~n ����� ������ Ȯ���ϼ���' )
				
			End if 
		END IF

	/* �ŷ�ó�� */
	Case "cvnas2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod )
				SetItem(1,"cvnas2",		scvnas)
			else
				Messagebox('Ȯ��', scvnas + '[ ' + sCvcod +  ' ]�� ��ϵ� ����� �ٸ��ϴ�. ~n ����� ������ Ȯ���ϼ���' )
			End if 

			Return 1
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//�ŷ�ó
		sCvcod 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas2', snull)
		End if 
 
		//���� ����
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'sarea', '')
		End if 
		
End Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod", "cvnas2"
		gs_gubun = '2'
		If GetColumnName() = "cvnas2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06540
integer x = 55
integer y = 312
integer width = 4530
integer height = 1992
string dataobject = "d_sal_06540"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06540
integer x = 855
integer y = 40
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('d_from')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'd_from', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06540
integer x = 1358
integer y = 40
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('d_to')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'd_to', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 304
integer width = 4553
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type


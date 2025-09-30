$PBExportHeader$w_qct_02500.srw
$PBExportComments$** ���Ƚ��� ���� ��Ȳ
forward
global type w_qct_02500 from w_standard_print
end type
end forward

global type w_qct_02500 from w_standard_print
integer width = 4640
integer height = 2440
string title = "���Ƚ��� ���� ��Ȳ"
end type
global w_qct_02500 w_qct_02500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, gu, dpt, jipdpt, jipdptnm, simdpt
string gutxt[3] = {"�Ϲ�����", "�׸�����", "ALL"} 
Long   i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
gu     = trim(dw_ip.object.gu[1])
dpt    = trim(dw_ip.object.dpt[1])
jipdpt = trim(dw_ip.object.jipdpt[1])
jipdptnm = trim(dw_ip.object.jipdptnm[1])
simdpt = trim(dw_ip.object.simdpt[1])

if (IsNull(sdate) or sdate = "")  then sdate = "100001"
if (IsNull(edate) or edate = "")  then edate = "999912"
if (IsNull(simdpt) or simdpt = "")  then simdpt = "%"

//CHOOSE CASE dpt
//	CASE "1" //���Ⱥμ� ����
//      if (IsNull(jipdpt) or jipdpt = "")  then
//	      f_message_chk(1400,'[����μ�]')
//	      dw_ip.SetColumn("jipdpt")
//	      dw_ip.Setfocus()
//	      return -1
//		end if	
//		dw_list.DataObject = "d_qct_02500_02"
//		dw_list.SetTransObject(SQLCA)
//		dw_list.object.txt_title.Text = "(" + jipdptnm + ")" + "��/���� ���� ���� ��Ȳ"
//      dw_list.object.txt_ymd.text = String(sdate, "@@@@��@@��") + " - " + String(edate, "@@@@��@@��")
//      dw_list.object.txt_gu.text = gutxt[Integer(gu)]
//      if (gu = "3") then gu = "%"  //like���� ���� ���ؼ�
//      i_rtn = dw_list.Retrieve(gs_sabu, sdate, edate, gu, jipdpt, simdpt)
//
//	CASE "2" //����μ� ����
//		dw_list.DataObject = "d_qct_02500_03"
//		dw_list.SetTransObject(SQLCA)
//      dw_list.object.txt_ymd.text = String(sdate, "@@@@��@@��") + " - " + String(edate, "@@@@��@@��")
//      dw_list.object.txt_gu.text = gutxt[Integer(gu)]
//		if (gu = "3") then gu = "%"  //like���� ���� ���ؼ�
//      i_rtn = dw_list.Retrieve(gs_sabu, sdate, edate, gu, simdpt)
//
//END CHOOSE
//
//if i_rtn <= 0 then
//	f_message_chk(50,'[���Ƚ��� ������Ȳ]')
//	dw_ip.Setfocus()
//	return -1
//end if

CHOOSE CASE dpt
	CASE "1" //���Ⱥμ� ����
      if (IsNull(jipdpt) or jipdpt = "")  then
	      f_message_chk(1400,'[����μ�]')
	      dw_ip.SetColumn("jipdpt")
	      dw_ip.Setfocus()
	      return -1
		end if	
		dw_list.DataObject = "d_qct_02500_02"
		dw_print.DataObject = "d_qct_02500_02"
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)

      if (gu = "3") then gu = "%"  //like���� ���� ���ؼ�

		IF dw_print.Retrieve(gs_sabu, sdate, edate, gu, jipdpt, simdpt) <= 0 then
			f_message_chk(50,'[���Ƚ��� ������Ȳ]')
			dw_list.Reset()
			dw_ip.SetFocus()
			dw_list.SetRedraw(true)
			dw_print.insertrow(0)
		//	Return -1
		END IF

		dw_print.ShareData(dw_list)

		dw_print.object.txt_title.Text = "(" + jipdptnm + ")" + "��/���� ���� ���� ��Ȳ"
      dw_print.object.txt_ymd.text = String(sdate, "@@@@��@@��") + " - " + String(edate, "@@@@��@@��")
      dw_print.object.txt_gu.text = gutxt[Integer(gu)]

	CASE "2" //����μ� ����
		dw_list.DataObject = "d_qct_02500_03"
		dw_print.DataObject = "d_qct_02500_03"
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)

		if (gu = "3") then gu = "%"  //like���� ���� ���ؼ�

		IF dw_print.Retrieve(gs_sabu, sdate, edate, gu, simdpt) <= 0 then
			f_message_chk(50,'[���Ƚ��� ������Ȳ]')
			dw_list.Reset()
			dw_ip.SetFocus()
			dw_list.SetRedraw(true)
			dw_print.insertrow(0)
		//	Return -1
		END IF

		dw_print.ShareData(dw_list)

      dw_list.object.txt_ymd.text = String(sdate, "@@@@��@@��") + " - " + String(edate, "@@@@��@@��")
      dw_list.object.txt_gu.text = gutxt[Integer(gu)]

END CHOOSE

return 1
end function

on w_qct_02500.create
call super::create
end on

on w_qct_02500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_02500
end type

type p_exit from w_standard_print`p_exit within w_qct_02500
end type

type p_print from w_standard_print`p_print within w_qct_02500
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_02500
end type







type st_10 from w_standard_print`st_10 within w_qct_02500
end type



type dw_print from w_standard_print`dw_print within w_qct_02500
string dataobject = "d_qct_02500_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_02500
integer x = 46
integer y = 0
integer width = 3150
integer height = 232
string dataobject = "d_qct_02500_01"
end type

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2
integer i_rtn
s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod + "01") = -1 then
		f_message_chk(35,"[���س��]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "jipdpt" then
	i_rtn = f_get_name2("�μ�", "N", s_cod, s_nam1, s_nam2)
	this.object.jipdpt[1] = s_cod
	this.object.jipdptnm[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "jipdpt"	THEN		
	open(w_vndmst_4_popup)
	this.SetItem(1, "jipdpt", gs_code)
	this.SetItem(1, "jipdptnm", gs_codename)
	return 
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_02500
string dataobject = "d_qct_02500_02"
end type


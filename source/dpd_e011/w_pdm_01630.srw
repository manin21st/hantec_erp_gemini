$PBExportHeader$w_pdm_01630.srw
$PBExportComments$** ���ϱ��� ����
forward
global type w_pdm_01630 from window
end type
type p_exit from uo_picture within w_pdm_01630
end type
type p_can from uo_picture within w_pdm_01630
end type
type p_print from uo_picture within w_pdm_01630
end type
type p_mod from uo_picture within w_pdm_01630
end type
type p_inq from uo_picture within w_pdm_01630
end type
type cb_1 from commandbutton within w_pdm_01630
end type
type dw_1 from datawindow within w_pdm_01630
end type
type st_1 from statictext within w_pdm_01630
end type
type dw_list2 from datawindow within w_pdm_01630
end type
type cb_cancel from commandbutton within w_pdm_01630
end type
type dw_datetime from datawindow within w_pdm_01630
end type
type cb_retrieve from commandbutton within w_pdm_01630
end type
type cb_exit from commandbutton within w_pdm_01630
end type
type cb_save from commandbutton within w_pdm_01630
end type
type dw_list from datawindow within w_pdm_01630
end type
type gb_2 from groupbox within w_pdm_01630
end type
type gb_mode2 from groupbox within w_pdm_01630
end type
type sle_msg from singlelineedit within w_pdm_01630
end type
type gb_10 from groupbox within w_pdm_01630
end type
type rr_1 from roundrectangle within w_pdm_01630
end type
type rr_2 from roundrectangle within w_pdm_01630
end type
end forward

global type w_pdm_01630 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "���ϱ��� ����"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_print p_print
p_mod p_mod
p_inq p_inq
cb_1 cb_1
dw_1 dw_1
st_1 st_1
dw_list2 dw_list2
cb_cancel cb_cancel
dw_datetime dw_datetime
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_save cb_save
dw_list dw_list
gb_2 gb_2
gb_mode2 gb_mode2
sle_msg sle_msg
gb_10 gb_10
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01630 w_pdm_01630

type variables
// �ڷắ�濩�� �˻�
boolean  ib_any_typing

String     is_today              //��������
String     is_totime             //���۽ð�
String     is_window_id      //������ ID
String     is_usegub           //�̷°��� ����
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : ����, ��Ͻ� ȣ���
		    dw_detail �� typing(datawindow) ������� �˻�

		 2. ��������� ��� ��������� ������� ������ ���                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : ��������� �������� �ʰ� ��� ������ ���.
			* -1 : ������ �ߴ��� ���.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	IF MessageBox("Ȯ�� : " + as_titletext , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r��������� �����Ͻðڽ��ϱ�", &
		 question!, yesno!) = 1 THEN

		dw_list.SetFocus()						// yes �� ���: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) �� ��������� ���ų� no�� ���
														// ��������� �������� �ʰ� ������� 

end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

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

integer icount, icount2, ilsu, ilsu2

dw_list.settransobject(sqlca)
dw_list2.settransobject(sqlca)

//�ʱ�ȭ
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)
    
	 SELECT "RESCAL"."GUILS"  
      INTO :ilsu  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)

    SELECT "RESCAL"."GUILS"  
      INTO :ilsu2  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

dw_datetime.insertrow(0)
end event

on w_pdm_01630.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_mod=create p_mod
this.p_inq=create p_inq
this.cb_1=create cb_1
this.dw_1=create dw_1
this.st_1=create st_1
this.dw_list2=create dw_list2
this.cb_cancel=create cb_cancel
this.dw_datetime=create dw_datetime
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.dw_list=create dw_list
this.gb_2=create gb_2
this.gb_mode2=create gb_mode2
this.sle_msg=create sle_msg
this.gb_10=create gb_10
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_can,&
this.p_print,&
this.p_mod,&
this.p_inq,&
this.cb_1,&
this.dw_1,&
this.st_1,&
this.dw_list2,&
this.cb_cancel,&
this.dw_datetime,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_save,&
this.dw_list,&
this.gb_2,&
this.gb_mode2,&
this.sle_msg,&
this.gb_10,&
this.rr_1,&
this.rr_2}
end on

on w_pdm_01630.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.dw_list2)
destroy(this.cb_cancel)
destroy(this.dw_datetime)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.gb_mode2)
destroy(this.sle_msg)
destroy(this.gb_10)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type p_exit from uo_picture within w_pdm_01630
integer x = 4398
integer y = 40
integer width = 178
integer taborder = 110
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

event clicked;call super::clicked;IF wf_warndataloss("����") = -1 THEN  	RETURN

close(parent)

end event

type p_can from uo_picture within w_pdm_01630
integer x = 4229
integer y = 40
integer width = 178
integer taborder = 90
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

integer icount, icount2, ilsu, ilsu2

//�ʱ�ȭ
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)

    SELECT "RESCAL"."GUILS"  
      INTO :ilsu  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)
    
	 SELECT "RESCAL"."GUILS"  
      INTO :ilsu2  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type p_print from uo_picture within w_pdm_01630
integer x = 4059
integer y = 40
integer width = 178
integer taborder = 120
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\�μ�_up.gif"
end type

event clicked;IF MessageBox("Ȯ��", "����Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN

dw_1.settransobject(sqlca)
dw_1.Retrieve() 
dw_1.print()

w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�μ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�μ�_up.gif"
end event

type p_mod from uo_picture within w_pdm_01630
integer x = 3890
integer y = 40
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;String ymd, symd, eymd, ymd2, sdate, sdate2
int  nguils, icount
long ljdat, ljdat2

IF dw_list.Accepttext() = -1 THEN 	
	dw_list.setfocus()
	RETURN
END IF
IF dw_list2.Accepttext() = -1 THEN 	
	dw_list.setfocus()
	RETURN
END IF

//////////////////////////////////////////////////////
//   �������� �ϼ��� ������ �����ϰ� �������� ���  //
//////////////////////////////////////////////////////

w_mdi_frame.sle_msg.text = '�۾����̿��� ��ø� ��ٷ��ּ���.!!!'
SetPointer(HourGlass!)

//cb_cancel.TriggerEvent("clicked")

ymd = f_today()

//ó�������� üũ
SELECT JDATE  
  INTO :sdate  
  FROM P4_CALENDAR  
 WHERE CLDATE = :ymd   ;

dw_list.SetItem(1, "gusdt", ymd)

FOR icount=1 TO 15
    nguils = dw_list.GetItemNumber(icount, "guils") 
    if isnull(nguils) or nguils = 0 then 
		 w_mdi_frame.sle_msg.text = ''
		 messagebox("Ȯ��", "�ϼ��� �Է��Ͻʽÿ�.!!")
       dw_list.SetRedraw(FALSE)
		 dw_list.setrow(icount)
		 dw_list.setfocus()
		 dw_list.SetRedraw(true)
    	 RETURN 1
	 end if

    symd   = dw_list.GetItemString(icount, "gusdt")
	 //�����Ϸ� calndr ���̺��� �о �ϼ�2�� ������ �´�
 	 SELECT JDATE  
      INTO :ljdat  
	   FROM P4_CALENDAR  
	  WHERE CLDATE = :symd   ;

	 ljdat = ljdat + nguils - 1  //����row�� �����ϼ�
	 ljdat2 = ljdat + 1          //����row�� �����ϼ� 
	 //����row�� ������ ������ ����
	 SELECT MAX(CLDATE)  
      INTO :eymd  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat ) ;
    //����row�� ������ ������ ����
	 SELECT MAX(CLDATE)
      INTO :ymd2  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat2 ) ;
    
	 dw_list.SetItem(icount, "guedt", eymd)
	 if icount <= 14 then
       dw_list.SetItem(icount+1, "gusdt", ymd2)
	 else
		 dw_list2.setitem(1 , "gusdt", ymd2)
	 end if
NEXT

FOR icount=1 TO 15
    nguils = dw_list2.GetItemNumber(icount, "guils") 
    if isnull(nguils) or nguils = 0  then 
		 w_mdi_frame.sle_msg.text = ''
		 messagebox("Ȯ��", "�ϼ��� �Է��Ͻʽÿ�.!!")
       dw_list2.SetRedraw(FALSE)
	 	 dw_list2.setrow(icount)
		 dw_list2.setfocus()
    	 dw_list2.SetRedraw(true)
		 RETURN 1
    end if

    symd   = dw_list2.GetItemString(icount, "gusdt")
 	 SELECT JDATE  
      INTO :ljdat  
	   FROM P4_CALENDAR  
	  WHERE CLDATE = :symd   ;
	 
	 ljdat = ljdat + nguils - 1
	 ljdat2 = ljdat + 1
	 
	 //����row�� ������ ������ ����
	 SELECT MAX(CLDATE)  
      INTO :eymd  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat ) ;
    //����row�� ������ ������ ����
	 SELECT MAX(CLDATE)
      INTO :ymd2  
      FROM P4_CALENDAR  
     WHERE ( JDATE = :ljdat2 ) ;
    
	 dw_list2.SetItem(icount, "guedt", eymd)
	 if icount <= 14 then
       dw_list2.SetItem(icount+1, "gusdt", ymd2)
	 end if
NEXT

//////////////////////////////////////////////////////////////////////////////

w_mdi_frame.sle_msg.text = ''

if f_msg_update() = -1 then return

DELETE FROM "RESCAL"  ;

IF dw_list.Update() > 0 THEN
	IF dw_list2.Update() > 0	THEN 
		
		COMMIT USING sqlca;
	ELSE
		ROLLBACK USING sqlca;
      messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
   END IF 
ELSE
	ROLLBACK USING sqlca;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
END IF

p_inq.TriggerEvent("clicked")

ib_any_typing = false
//w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_inq from uo_picture within w_pdm_01630
integer x = 3721
integer y = 40
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;call super::clicked;integer icount, icount2, ilsu, ilsu2
string  sdate, edate 

dw_list.settransobject(sqlca)
dw_list2.settransobject(sqlca)

//�ʱ�ȭ
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)
    
	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
      INTO :ilsu,   :sdate, :edate  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    dw_list.SetItem(icount, "gusdt", sdate)
    dw_list.SetItem(icount, "guedt", edate)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)

	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
      INTO :ilsu2,   :sdate, :edate  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
    dw_list2.SetItem(icount, "gusdt", sdate)
    dw_list2.SetItem(icount, "guedt", edate)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

//w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ȸ_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ȸ_up.gif"
end event

type cb_1 from commandbutton within w_pdm_01630
boolean visible = false
integer x = 1490
integer y = 2868
integer width = 352
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "��ȸ(&R)"
end type

event clicked;call super::clicked;//integer icount, icount2, ilsu, ilsu2
//string  sdate, edate 
//
//dw_list.settransobject(sqlca)
//dw_list2.settransobject(sqlca)
//
////�ʱ�ȭ
//dw_list.setredraw(false)
//dw_list2.setredraw(false)
//
//dw_list.reset()
//dw_list2.reset()
//
//FOR icount=1 TO 15
//    dw_list.insertrow(0)
//    dw_list.SetItem(icount, "gugan", icount)
//    
//	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
//      INTO :ilsu,   :sdate, :edate  
//      FROM "RESCAL"  
//     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
//    dw_list.SetItem(icount, "guils", ilsu)
//    dw_list.SetItem(icount, "gusdt", sdate)
//    dw_list.SetItem(icount, "guedt", edate)
//    
//	 icount2 = icount + 15
//	 dw_list2.insertrow(0)
//    dw_list2.SetItem(icount, "gugan", icount2)
//
//	 SELECT "RESCAL"."GUILS", "RESCAL"."GUSDT", "RESCAL"."GUEDT"    
//      INTO :ilsu2,   :sdate, :edate  
//      FROM "RESCAL"  
//     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
//    dw_list2.SetItem(icount, "guils", ilsu2)
//    dw_list2.SetItem(icount, "gusdt", sdate)
//    dw_list2.SetItem(icount, "guedt", edate)
//NEXT
//
//dw_list.SetFocus()
//
//dw_list.setredraw(true)
//dw_list2.setredraw(true)
//
//ib_any_typing = false
//
end event

type dw_1 from datawindow within w_pdm_01630
boolean visible = false
integer x = 613
integer y = 2944
integer width = 782
integer height = 92
boolean titlebar = true
string title = "���� No�� �����ϼ� ���"
string dataobject = "d_pdm_01630_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pdm_01630
boolean visible = false
integer x = 73
integer y = 3244
integer width = 347
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = "�޼���"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_list2 from datawindow within w_pdm_01630
event ue_pressenter pbm_dwnprocessenter
integer x = 2354
integer y = 284
integer width = 1746
integer height = 1888
integer taborder = 30
string dataobject = "d_pdm_01630"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;	ib_any_typing = true

end event

type cb_cancel from commandbutton within w_pdm_01630
boolean visible = false
integer x = 2807
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
boolean cancel = true
end type

event clicked;sle_msg.text = ''

integer icount, icount2, ilsu, ilsu2

//�ʱ�ȭ
dw_list.setredraw(false)
dw_list2.setredraw(false)

dw_list.reset()
dw_list2.reset()

FOR icount=1 TO 15
    dw_list.insertrow(0)
    dw_list.SetItem(icount, "gugan", icount)

    SELECT "RESCAL"."GUILS"  
      INTO :ilsu  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount )   ;
    dw_list.SetItem(icount, "guils", ilsu)
    
	 icount2 = icount + 15
	 dw_list2.insertrow(0)
    dw_list2.SetItem(icount, "gugan", icount2)
    
	 SELECT "RESCAL"."GUILS"  
      INTO :ilsu2  
      FROM "RESCAL"  
     WHERE ( "RESCAL"."GUGAN" = :icount2 )   ;
    dw_list2.SetItem(icount, "guils", ilsu2)
NEXT

dw_list.SetFocus()

dw_list.setredraw(true)
dw_list2.setredraw(true)

ib_any_typing = false

end event

type dw_datetime from datawindow within w_pdm_01630
boolean visible = false
integer x = 2917
integer y = 3244
integer width = 745
integer height = 96
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type cb_retrieve from commandbutton within w_pdm_01630
boolean visible = false
integer x = 2437
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&P)"
end type

event clicked;call super::clicked;//IF MessageBox("Ȯ��", "����Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN
//
//dw_1.settransobject(sqlca)
//dw_1.Retrieve() 
//dw_1.print()
end event

type cb_exit from commandbutton within w_pdm_01630
boolean visible = false
integer x = 3177
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
boolean cancel = true
end type

event clicked;call super::clicked;//
//IF wf_warndataloss("����") = -1 THEN  	RETURN
//
//close(parent)


end event

type cb_save from commandbutton within w_pdm_01630
boolean visible = false
integer x = 2066
integer y = 2852
integer width = 352
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;call super::clicked;//String ymd, symd, eymd, ymd2, sdate, sdate2
//int  nguils, icount
//long ljdat, ljdat2
//
//IF dw_list.Accepttext() = -1 THEN 	
//	dw_list.setfocus()
//	RETURN
//END IF
//IF dw_list2.Accepttext() = -1 THEN 	
//	dw_list.setfocus()
//	RETURN
//END IF
//
////////////////////////////////////////////////////////
////   �������� �ϼ��� ������ �����ϰ� �������� ���  //
////////////////////////////////////////////////////////
//
//sle_msg.text = '�۾����̿��� ��ø� ��ٷ��ּ���.!!!'
//SetPointer(HourGlass!)
//
////cb_cancel.TriggerEvent("clicked")
//
//ymd = f_today()
//
////ó�������� üũ
//SELECT JDATE  
//  INTO :sdate  
//  FROM P4_CALENDAR  
// WHERE CLDATE = :ymd   ;
//
//dw_list.SetItem(1, "gusdt", ymd)
//
//FOR icount=1 TO 15
//    nguils = dw_list.GetItemNumber(icount, "guils") 
//    if isnull(nguils) or nguils = 0 then 
//		 sle_msg.text = ''
//		 messagebox("Ȯ��", "�ϼ��� �Է��Ͻʽÿ�.!!")
//       dw_list.SetRedraw(FALSE)
//		 dw_list.setrow(icount)
//		 dw_list.setfocus()
//		 dw_list.SetRedraw(true)
//    	 RETURN 1
//	 end if
//
//    symd   = dw_list.GetItemString(icount, "gusdt")
//	 //�����Ϸ� calndr ���̺��� �о �ϼ�2�� ������ �´�
// 	 SELECT JDATE  
//      INTO :ljdat  
//	   FROM P4_CALENDAR  
//	  WHERE CLDATE = :symd   ;
//
//	 ljdat = ljdat + nguils - 1  //����row�� �����ϼ�
//	 ljdat2 = ljdat + 1          //����row�� �����ϼ� 
//	 //����row�� ������ ������ ����
//	 SELECT MAX(CLDATE)  
//      INTO :eymd  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat ) ;
//    //����row�� ������ ������ ����
//	 SELECT MAX(CLDATE)
//      INTO :ymd2  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat2 ) ;
//    
//	 dw_list.SetItem(icount, "guedt", eymd)
//	 if icount <= 14 then
//       dw_list.SetItem(icount+1, "gusdt", ymd2)
//	 else
//		 dw_list2.setitem(1 , "gusdt", ymd2)
//	 end if
//NEXT
//
//FOR icount=1 TO 15
//    nguils = dw_list2.GetItemNumber(icount, "guils") 
//    if isnull(nguils) or nguils = 0  then 
//		 sle_msg.text = ''
//		 messagebox("Ȯ��", "�ϼ��� �Է��Ͻʽÿ�.!!")
//       dw_list2.SetRedraw(FALSE)
//	 	 dw_list2.setrow(icount)
//		 dw_list2.setfocus()
//    	 dw_list2.SetRedraw(true)
//		 RETURN 1
//    end if
//
//    symd   = dw_list2.GetItemString(icount, "gusdt")
// 	 SELECT JDATE  
//      INTO :ljdat  
//	   FROM P4_CALENDAR  
//	  WHERE CLDATE = :symd   ;
//	 
//	 ljdat = ljdat + nguils - 1
//	 ljdat2 = ljdat + 1
//	 
//	 //����row�� ������ ������ ����
//	 SELECT MAX(CLDATE)  
//      INTO :eymd  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat ) ;
//    //����row�� ������ ������ ����
//	 SELECT MAX(CLDATE)
//      INTO :ymd2  
//      FROM P4_CALENDAR  
//     WHERE ( JDATE = :ljdat2 ) ;
//    
//	 dw_list2.SetItem(icount, "guedt", eymd)
//	 if icount <= 14 then
//       dw_list2.SetItem(icount+1, "gusdt", ymd2)
//	 end if
//NEXT
//
////////////////////////////////////////////////////////////////////////////////
//
//sle_msg.text = ''
//
//if f_msg_update() = -1 then return
//
//DELETE FROM "RESCAL"  ;
//
//IF dw_list.Update() > 0 THEN
//	IF dw_list2.Update() > 0	THEN 
//		
//		COMMIT USING sqlca;
//	ELSE
//		ROLLBACK USING sqlca;
//      messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//   END IF 
//ELSE
//	ROLLBACK USING sqlca;
//   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
//END IF
//
//cb_1.TriggerEvent("clicked")
//
//ib_any_typing = false
end event

type dw_list from datawindow within w_pdm_01630
event ue_pressenter pbm_dwnprocessenter
integer x = 453
integer y = 284
integer width = 1746
integer height = 1888
integer taborder = 20
string dataobject = "d_pdm_01630"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;	ib_any_typing = true

end event

type gb_2 from groupbox within w_pdm_01630
boolean visible = false
integer x = 1445
integer y = 2800
integer width = 439
integer height = 204
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_mode2 from groupbox within w_pdm_01630
boolean visible = false
integer x = 2025
integer y = 2784
integer width = 1541
integer height = 204
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65535
long backcolor = 79741120
end type

type sle_msg from singlelineedit within w_pdm_01630
boolean visible = false
integer x = 425
integer y = 3244
integer width = 2491
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 79741120
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type gb_10 from groupbox within w_pdm_01630
boolean visible = false
integer x = 59
integer y = 3192
integer width = 3611
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

type rr_1 from roundrectangle within w_pdm_01630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 439
integer y = 272
integer width = 1792
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2341
integer y = 272
integer width = 1792
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type


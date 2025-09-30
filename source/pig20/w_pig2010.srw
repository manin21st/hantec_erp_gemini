$PBExportHeader$w_pig2010.srw
$PBExportComments$�ڷ� ����(������ȹ/��������)
forward
global type w_pig2010 from window
end type
type p_can from uo_picture within w_pig2010
end type
type p_mod from uo_picture within w_pig2010
end type
type dw_update from u_key_enter within w_pig2010
end type
type rr_1 from roundrectangle within w_pig2010
end type
end forward

global type w_pig2010 from window
integer width = 3177
integer height = 1892
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 32106727
p_can p_can
p_mod p_mod
dw_update dw_update
rr_1 rr_1
end type
global w_pig2010 w_pig2010

type variables
String  IsMode
end variables

forward prototypes
public function long wf_date (string sdate, string edate)
public function long wf_time (string stime, string etime)
end prototypes

public function long wf_date (string sdate, string edate);string temp_date1, temp_date2
long ll_temp1

if isnull(sdate) or sdate = "" then return -1
if isnull(edate) or edate = "" then return -1

temp_date1 = string(left(sdate, 4) + "/"+ mid(sdate, 5,2) + "/" + &
				 right(sdate, 2))
temp_date2 = string(left(edate, 4) + "/"+ mid(edate, 5,2) + "/" + &
				 right(edate, 2))
ll_temp1 = 	daysafter(date(temp_date1), date(temp_date2)) + 1

return ll_temp1

end function

public function long wf_time (string stime, string etime);string ls_stime, ls_etime
long ll_time1, ll_time2

ls_stime = stime
ls_etime = etime

if isnull(ls_stime) or  ls_stime = "" then return -1
if isnull(ls_etime) or  ls_etime = "" then return -1

ll_time1 = (long ( left (ls_etime, 2 ) ) * 60  + long ( right (ls_etime, 2))) - &
				(long ( left (ls_stime, 2 ) ) * 60  + long (right (ls_stime, 2)))

if ll_time1 < 60 then
  	ll_time2	= 0
else 
	ll_time2 = truncate(ll_time1/60, 0) // + (mod(ll_time1, 60 ))/100 
	
end if

return ll_time2

end function

on w_pig2010.create
this.p_can=create p_can
this.p_mod=create p_mod
this.dw_update=create dw_update
this.rr_1=create rr_1
this.Control[]={this.p_can,&
this.p_mod,&
this.dw_update,&
this.rr_1}
end on

on w_pig2010.destroy
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.dw_update)
destroy(this.rr_1)
end on

event open;
F_Window_Center_Response(This)

String   sMsg,sEduYear,sEduEmp
Integer  iEduSeq

IsMode = Left(Message.StringParm,1)
sMsg   = Mid(Message.StringParm,2,15)

sEduYear = Mid(sMsg,1,4)
iEduSeq  = Integer(Mid(sMsg,5,4))
sEduEmp  = Mid(sMsg,9,6)

if IsMode = 'S' then					/*������ȹ*/
	this.Title = '������ȹ ����'
	dw_update.DataObject = 'd_pig20101'
else										/*��������*/
	this.Title = '�������� ����'
	dw_update.DataObject = 'd_pig20102'
end if
dw_update.SetTransObject(Sqlca)
dw_update.Reset()

if dw_update.Retrieve(gs_company,sEduYear,iEduSeq,sEduEmp) <=0 then
	Close(this)
	Return
end if

if IsMode = 'S' then					/*������ȹ*/
	dw_update.SetColumn("restartdate")
else
	dw_update.SetColumn("eduno")
end if
dw_update.SetFocus()

end event

type p_can from uo_picture within w_pig2010
integer x = 2926
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

event clicked;call super::clicked;Rollback;

CloseWithReturn(w_pig2010,'0')
end event

type p_mod from uo_picture within w_pig2010
integer x = 2752
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;
if dw_update.AcceptText() = -1 then Return

if dw_update.GetRow() <=0 then Return

if f_msg_update() = -1 then return

if dw_update.update() <> 1 then
	rollback;
	MessageBox("Ȯ��", "�������")
	return
end if
Commit;

CloseWithReturn(w_pig2010,'1')
end event

type dw_update from u_key_enter within w_pig2010
integer x = 96
integer y = 176
integer width = 2967
integer height = 1520
integer taborder = 10
string dataobject = "d_pig20101"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;IF this.GetColumnName() ="edudept" THEN
	SetNull(Gs_Code); SetNull(Gs_Codename);
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"edudept",gs_code)
   this.TriggerEvent(ItemChanged!)	
END IF
end event

event itemchanged;String  sValue,ls_restartdate,ls_reenddate,ls_starttime,ls_endtime,ls_edudept,sDeptcode,sDeptCodeName
Long    ll_datesu,ll_time1

setNull(svalue)

IF this.GetColumnName() ="restartdate"THEN
	if isnull(data) or trim(data) = "" then 
		MessageBox("Ȯ ��", "���� �������ڴ� �ʼ��Է»����Դϴ�.!!")			
		return 1
	end if
	If f_datechk(data) = -1 Then
		MessageBox("Ȯ ��", "��ȿ�� ���ڰ� �ƴմϴ�.")
		Return 1
	end if
	ls_restartdate = data
	ls_reenddate = this.GetItemstring(1, 'reenddate')
	
	//�������ڰ� �������� ������, �������ڸ� �Է��Ѵ�.
	if isnull(ls_reenddate) or trim(ls_reenddate) = "" then 
		ls_reenddate = ls_restartdate
		this.SetItem(1, 'reenddate', ls_reenddate)			
	end if
	
	// ���ϼ��� ���ϴ� function(�ϼ��� ���ϴµ� �����ϸ� -1, �ƴϸ� ���ϼ� ���� return )
	if wf_date(ls_restartdate, ls_reenddate) = -1 then 
		MessageBox("Ȯ ��", "�ϼ��� ���ϴµ� �����Ͽ����ϴ�.!!")
		return 1
	else
	  ll_datesu = wf_date(ls_restartdate, ls_reenddate)			
	end if
	
	this.setItem(1, 'datesu', ll_datesu)		
	
	ll_time1 = this.GetItemNumber(1, 'temp1')		
	
	if isnull(ll_time1) or  string(ll_time1) = "" then 
		ll_time1 = 0 
	end if
	
	// ���ϼ��� �ѽð��� �����Ѵ�.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    
		
END IF

IF this.GetColumnName() ="reenddate"THEN
	if isnull(data) or trim(data) = "" then 
		MessageBox("Ȯ ��", "���� �������ڴ� �ʼ��Է»����Դϴ�.!!")
		return 1		
	end if
	If f_datechk(data) = -1 Then
		MessageBox("Ȯ ��", "��ȿ�� ���ڰ� �ƴմϴ�.")
		Return 1
	end if
	
	ls_restartdate = this.GetItemstring(1, 'restartdate')
	ls_reenddate = data		
	
	if  ls_restartdate > ls_reenddate then
		MessageBox("Ȯ ��", "�������ڰ� �������ں���" + "~n" + &
								 "Ŭ ���� �����ϴ�.!!", stopsign!)
		return 1
	end if
	
	//�������ڰ� �������� ������, �������ڸ� �Է��Ѵ�.
	if isnull(ls_restartdate) or ls_restartdate = "" then 
		ls_restartdate = ls_reenddate 
		this.SetItem(1, 'restartdate', ls_restartdate)						
	end if
	
	// ���ϼ��� ���ϴ� function(�ϼ��� ���ϴµ� �����ϸ� -1, �ƴϸ� ���ϼ� ���� return )
	if wf_date(ls_restartdate, ls_reenddate) = -1 then 
		MessageBox("Ȯ ��", "�ϼ��� ���ϴµ� �����Ͽ����ϴ�.!!")
		return 
	else
	  ll_datesu = wf_date(ls_restartdate, ls_reenddate)			
	end if
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu= 0 
	end if
	
	ll_time1 = this.GetItemNumber(1, 'temp1')		
	
	if isnull(ll_time1) or string(ll_time1) = "" then 
		ll_time1 = 0 
	end if
	
	// ���ϼ��� �ѽð��� �����Ѵ�.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    

END IF

if this.GetColumnName() = 'starttime' then
	ls_starttime = string(long(data), '00:00')
	if Istime(ls_starttime) = false Then
		MessageBox("Ȯ ��", "��ȿ�� �ð��� �ƴմϴ�.")			
		return 1
	end if	
	ls_endtime = string(this.GetItemNumber(1, 'endtime'), '00:00')
	
	if isnull(ls_endtime) or ls_endtime = ""  or ls_endtime ="00:00" then
		ls_endtime = data
		this.SetItem(1, 'endtime',  long(ls_endtime))			
	end if
	
	ll_datesu = this.GetItemNumber(1, 'datesu')				

	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("Ȯ ��", "�ð� ���� ����")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if
	
	if isnull(ll_time1) or string(ll_time1) = ""  then ll_time1 = 0
	
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    		
end if

if this.GetColumnName() = 'endtime' then
	ls_endtime = string(long(data), '00:00')
	if Istime(ls_endtime) = false Then
		MessageBox("Ȯ ��", "��ȿ�� �ð��� �ƴմϴ�.")			
		return 1
	end if
	ls_starttime = string(this.GetItemNumber(1, 'starttime'), & 
										'00:00')
	if ls_starttime > ls_endtime then
		MessageBox("Ȯ ��", "���� �ð��� ����ð�����" + "~n" + & 
								 "Ŭ ���� �����ϴ�.!!")			
		return 1
	end if
	
	if isnull(ls_starttime) or string(ls_starttime) = "" then
		ls_starttime = data  
		this.SetItem(1, 'starttime',  long(ls_starttime))			
	end if

	ll_datesu = this.GetItemNumber(1, 'datesu')				
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("Ȯ ��", "�ð� ���� ����")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if

	if isnull(ll_time1) or string(ll_time1) = "" then ll_time1 = 0
		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    		

end if

if this.GetColumnName() = 'datesu' then
	ll_datesu = long(data)
	if isnull(ll_datesu)  or ll_datesu = 0 or string(ll_datesu) = "" then 
		ll_datesu = 0
		this.setItem(1, 'datsu', 0)    		
	end if
	
	// �ѱ����ð�, �����ϼ� * �����ð�
	ll_time1 = this.GetItemNumber(1, 'temp1') 
	if isnull(ll_time1) or string(ll_time1) = "" then
		ll_time1 = 0 
	end if
	
	this.SetItem(1, 'ehour', ll_datesu * ll_time1)
end if

// �ְ��μ�
IF this.GetColumnName() ="edudept"THEN
	ls_edudept = this.GetItemString(1, 'edudept')
	
	if trim(ls_edudept) = "" or isnull(ls_edudept) then return
	
	select deptcode, deptname
	into   :sdeptcode, :sdeptcodename
	from p0_dept
	where companycode = :gs_company and
			deptcode    = :ls_edudept ;
	if sqlca.sqlcode <> 0 then
		MessageBox("Ȯ ��", "��ȸ�� �ڷᰡ �����ϴ�.")
	   this.SetItem(row, 'edudept', svalue)
		return 1
	end if
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_pig2010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 156
integer width = 3040
integer height = 1568
integer cornerheight = 40
integer cornerwidth = 55
end type


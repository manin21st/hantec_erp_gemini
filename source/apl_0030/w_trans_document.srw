$PBExportHeader$w_trans_document.srw
$PBExportComments$문서로 연결
forward
global type w_trans_document from window
end type
type dw_dept from datawindow within w_trans_document
end type
type dw_1 from u_key_enter within w_trans_document
end type
type cb_2 from commandbutton within w_trans_document
end type
type cb_1 from commandbutton within w_trans_document
end type
type gb_2 from groupbox within w_trans_document
end type
type gb_1 from groupbox within w_trans_document
end type
end forward

global type w_trans_document from window
integer x = 155
integer y = 16
integer width = 3250
integer height = 2372
boolean titlebar = true
string title = "전자결재 문서로 저장"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
dw_dept dw_dept
dw_1 dw_1
cb_2 cb_2
cb_1 cb_1
gb_2 gb_2
gb_1 gb_1
end type
global w_trans_document w_trans_document

type variables
datawindow   Idw_Save
String             LsPath
end variables

forward prototypes
public function integer wf_attach_file (string sdono, string sfilename)
end prototypes

public function integer wf_attach_file (string sdono, string sfilename);Long      lFileLength
Integer   iOpenSts
String    sFullFileName
Blob      ImageData,TempBlob

delete from grdoatta where gr_dono = :sDoNo;

sFullFileName = LsPath + sFileName
lFileLength   = FileLength(sFullFileName)

iOpenSts = FileOpen(sFullFileName, StreamMode!, Read!, LockRead!)
IF iOpenSts <= 0 THEN
	Messagebox("알 림",sFullFileName + "은 첨부할 수 없는화일 입니다.") 
	Return -1
END IF

insert into grdoatta
	(gr_dono,			gr_seq,			gr_addfile,			gr_pathname,				gr_length)
values
	(:sDoNo,				1,					:sFileName,			:LsPath||:sFileName,		:lFileLength);
if sqlca.sqlcode <> 0 then
	F_MessageChk(13,'[파일첨부]')
	Rollback;
	Return -1
end if
Commit;

imagedata = Blob(Space(0))

/*파일을 읽기*/
DO
	IF FileRead(iOpenSts, TempBlob ) <= 0 THEN EXIT
	ImageData += TempBlob
LOOP WHILE TRUE
FileClose(iOpenSts)

SQLCA.AutoCommit = TRUE
UPDATEBLOB grdoatta
		 SET gr_blob    = :imagedata
	  WHERE gr_dono = :sDoNo	and gr_seq  = 1 Using Sqlca;
SQLCA.AutoCommit = False

IF sqlca.sqlcode <> 0 or sqlca.sqldbcode <> 0 THEN
	MessageBox("DB ERROR", String(Sqlca.SqlCode) + '/' + String(Sqlca.SqlDbCode) + '/' +&
					Sqlca.SqlErrText)
	rollback;
	return -1
END IF

Return 1
end function

on w_trans_document.create
this.dw_dept=create dw_dept
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.dw_dept,&
this.dw_1,&
this.cb_2,&
this.cb_1,&
this.gb_2,&
this.gb_1}
end on

on w_trans_document.destroy
destroy(this.dw_dept)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;String    sKey,sDrive
Integer   iRtn

F_Window_Center_Response(This)

Idw_Save = Message.PowerObjectParm

sKey  = "HKEY_LOCAL_MACHINE\SOFTWARE\ERP MANAGER\"
iRtn  = 	RegistryGet(sKey + "Drive_Name", 		"Dvl", RegString!, sDrive) 

LsPath = sDrive + Upper("erpman\grpware\psr\")

dw_1.SetTransObject(Sqlca)
dw_1.Reset()
dw_1.InsertRow(0)

dw_dept.SetTransObject(Sqlca)
dw_dept.Retrieve()

dw_1.Modify("path_t.text = '" + LsPath + "'")

dw_1.SetColumn("filename")
dw_1.SetFocus()
	
end event

type dw_dept from datawindow within w_trans_document
integer x = 91
integer y = 1868
integer width = 3049
integer height = 156
integer taborder = 20
string dataobject = "dw_trans_sudept"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_1 from u_key_enter within w_trans_document
integer x = 18
integer y = 8
integer width = 3163
integer height = 1804
integer taborder = 10
string dataobject = "dw_trans_document"
boolean border = false
end type

event itemchanged;String sLastId,sJikWi,sDocCls,sNull

SetNull(sNull)

if this.GetColumnName() = "doccls" then
	sDocCls = this.GetText()
	if sDocCls = '' OR IsNull(sDocCls) then Return
	
	select grrfcd into :sDocCls from grref	
		where grrfcd <> '00' and grrfgu = '20' and grrfcd = :sDocCls and Length(grrfcd) = 6 ;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[문서분류]')
		this.SetItem(1,"doccls",   sNull)
		Return 1
	end if
end if

if this.GetColumnName() = 'lastid' then
	sLastId = this.GetText()
	
	if sLastId = '' or IsNull(sLastId) then 
		this.SetItem(1,"jikwi",sNull)
		Return
	end if
	
	select gr_jikwi		into :sJikWi	from gruser where gr_userid = :sLastId;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[최종결재자]')
		this.SetItem(1,"lastid",   sNull)
		this.SetItem(1,"jikwi",    sNull)
		Return 1
	else
		this.SetItem(1,"jikwi", sJikWi)
	end if
end if
end event

event itemerror;Return 1
end event

event itemfocuschanged;IF this.GetColumnName() = 'title' OR this.GetColumnName() = 'contents' THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type cb_2 from commandbutton within w_trans_document
integer x = 2423
integer y = 2092
integer width = 347
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;CloseWithReturn(parent,'0')
end event

type cb_1 from commandbutton within w_trans_document
integer x = 2789
integer y = 2092
integer width = 347
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "완료(&F)"
end type

event clicked;String   sFileName,sDocGbn,sDocNo,sDocCls,sLastId,sTitle,sContents,sCurrDate,sCurrTime,sEmpName,sDeptName,&
         sSusinDeptName,sSusinDept,sSusinEmpNo
Integer  iMaxSeq,iSusinCnt,k

if dw_1.AcceptText() = -1 then Return
sFileName = dw_1.GetItemString(1,"filename")
sDocGbn   = dw_1.GetItemString(1,"docgbn")
sDocCls   = dw_1.GetItemString(1,"doccls")
sLastId   = dw_1.GetItemString(1,"lastid")
sTitle    = dw_1.GetItemString(1,"title")
sContents = dw_1.GetItemString(1,"contents")

if sFileName = '' OR IsNull(sFileName) then
	F_MessageChk(1,'[파일명]')
	dw_1.SetColumn("filename")
	dw_1.SetFocus()
	Return
else
	sFileName = Upper(sFileName + '.psr')
end if
if sDocGbn = '' OR IsNull(sDocGbn) then
	F_MessageChk(1,'[문서구분]')
	dw_1.SetColumn("docgbn")
	dw_1.SetFocus()
	Return
end if
if sDocCls = '' OR IsNull(sDocCls) then
	F_MessageChk(1,'[문서분류]')
	dw_1.SetColumn("doccls")
	dw_1.SetFocus()
	Return
end if
if sTitle = '' OR IsNull(sTitle) then
	F_MessageChk(1,'[제목]')
	dw_1.SetColumn("title")
	dw_1.SetFocus()
	Return
end if

if Idw_Save.saveas(LsPath + sFileName,PSReport!,True) = -1 then
	F_MessageChk(13,'[파일 저장]')
	dw_1.SetColumn("filename")
	dw_1.SetFocus()
	Return
end if

select to_char(sysdate,'yyyymmdd'),	to_char(sysdate,'hhmmss')	into :sCurrDate,  :sCurrTime	from dual;

select to_number(max(substr(gr_dono,9,3)))	into :iMaxSeq	from grdotitle;
if sqlca.sqlcode <> 0 or IsNull(iMaxSeq) then
	iMaxSeq = 0
else
	if IsNull(iMaxSeq) then iMaxSeq = 0
end if

sDocNo    = sCurrDate + String(iMaxSeq + 1,'000')
sEmpName  = F_Get_PersonLst('4',Gs_EmpNo,'%')
sDeptName = F_Get_PersonLst('3',Gs_Dept,'%')

sSusinDeptName = ''

iSusinCnt = dw_dept.RowCount()
FOR k = 1 TO iSusinCnt
	IF dw_dept.GetItemString(k, 'flag') = '1' THEN 
		sSusinDept      = dw_dept.GetItemString(k, 'gr_deptcode')
		sSusinDeptName  = sSusinDeptName + dw_dept.GetItemString(k,'gr_deptname') + ','
		sSusinEmpNo     = dw_dept.GetItemString(k, 'gr_susin')
				
		insert into grdodept
			(gr_dono,		deptcode,		deptemp,			gr_status,		gr_subal)
		values
			(:sDocNo,		:sSusinDept, 	:sSusinEmpNo,	'0',				'2' ) ;
		if sqlca.sqlcode <> 0 then
			F_MessageChk(13,'[수신부서]')
			RollBack;
			Return
		end if
	end if			
NEXT

sSusinDeptName = Left(sSusinDeptName, Len(sSusinDeptName) - 1)

insert into grdotitle
(	gr_dono,			gr_dotitle,			gr_userid,			gr_name,				gr_deptcode,
	gr_deptname,	gr_sdate,			gr_stime,			gr_dogbn,			gr_docat1,
	gr_docat2,		gr_docnm,			
	gr_urgent,		gr_status,			gr_currseq,			gr_reftext,
	gr_formno,		gr_contents,		gr_rcvtext,			gr_doccls,			gr_lastid)
values
(	:sDocNo,			:sTitle,				:Gs_UserId,			:sEmpName,			:Gs_Dept,
	:sDeptName,		:sCurrDate,			:sCurrTime,			:sDocGbn,			null,
	null,				decode(:sDocGbn,'001','협조전','002','품의서','기타문서'),			
	'N',				'0',					'',					:sFileName,
	'',				:sContents,			:sSusinDeptName,	:sDocCls,			:sLastId ) ;
if sqlca.sqlcode <> 0 then
	F_MessageChk(13,'[문서정보]')
	Rollback;
	Return
end if

insert into grdoline
(	gr_dono,				gr_subal,			gr_deptcode,		
	gr_upuserid,		gr_upseq,			gr_gubun,		gr_damdept	)
values
(	:sDocNo,				'1',					:Gs_Dept,	
	:Gs_UserId,			0,						'0',				:Gs_Dept	)	;
if sqlca.sqlcode <> 0 then
	F_MessageChk(13,'[문서결재정보]')
	Rollback;
	Return
end if

If Wf_Attach_File(sDocNo, sFileName) = -1 THEN 
	Rollback;
	Return
end if
Commit;

CloseWithReturn(parent,'1')




end event

type gb_2 from groupbox within w_trans_document
integer x = 46
integer y = 1812
integer width = 3127
integer height = 228
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "수신 부서"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_trans_document
integer x = 2391
integer y = 2040
integer width = 782
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type


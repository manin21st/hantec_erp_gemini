$PBExportHeader$w_sal_02000_3.srw
$PBExportComments$수주 등록(거래처 여신상세 조회)
forward
global type w_sal_02000_3 from window
end type
type p_1 from uo_picture within w_sal_02000_3
end type
type dw_rtv from datawindow within w_sal_02000_3
end type
end forward

global type w_sal_02000_3 from window
integer x = 283
integer y = 664
integer width = 2981
integer height = 804
boolean titlebar = true
string title = "여신 상세 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
dw_rtv dw_rtv
end type
global w_sal_02000_3 w_sal_02000_3

on w_sal_02000_3.create
this.p_1=create p_1
this.dw_rtv=create dw_rtv
this.Control[]={this.p_1,&
this.dw_rtv}
end on

on w_sal_02000_3.destroy
destroy(this.p_1)
destroy(this.dw_rtv)
end on

event open;String  sMsgParm,sCust,sSuJuYm,sCurrentDate
Integer iYusinRate,iRate21,iRate22,iRate23,iRate24,iRate25,iRate26,iRate27

dw_rtv.SetTransObject(SQLCA)
dw_rtv.Reset()

sMsgParm = Message.StringParm

sSuJuYm = Left(sMsgParm,6)
sCust   = Mid(sMsgParm,7,6)

sCurrentDate = f_today()

IF dw_rtv.Retrieve(gs_sabu,sCust,sSuJuYm,sCurrentDate) <=0 THEN
	f_message_chk(50,'[여신 정보]')
	CLOSE(w_sal_02000_1)
	Return
END IF

SELECT Max(DECODE("SYSCNFG"."LINENO",'20',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'21',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'22',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'23',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'24',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'25',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'26',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0)),
		 Max(DECODE("SYSCNFG"."LINENO",'27',TO_NUMBER(SUBSTR("SYSCNFG"."DATANAME",1,3)),0))
	INTO :iYusinRate,	:iRate21,:iRate22,:iRate23,:iRate24,:iRate25,:iRate26,:iRate27
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'S' ) AND  
         ( "SYSCNFG"."SERIAL" = 2 ) AND ("SYSCNFG"."LINENO" <> '00')  ;
			
dw_rtv.SetItem(1,"yusinratelimit",iYusinRate)
dw_rtv.SetItem(1,"irate1",iRate21)
dw_rtv.SetItem(1,"irate2",iRate22)
dw_rtv.SetItem(1,"irate3",iRate23)
dw_rtv.SetItem(1,"irate4",iRate24)
dw_rtv.SetItem(1,"irate5",iRate25)
dw_rtv.SetItem(1,"irate6",iRate26)
dw_rtv.SetItem(1,"irate7",iRate27)
			
f_window_center_response(this)
end event

type p_1 from uo_picture within w_sal_02000_3
integer x = 2738
integer y = 8
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;call super::clicked;close(Parent)
end event

type dw_rtv from datawindow within w_sal_02000_3
integer x = 9
integer y = 164
integer width = 2926
integer height = 552
string dataobject = "d_sal_02000_3"
boolean border = false
boolean livescroll = true
end type


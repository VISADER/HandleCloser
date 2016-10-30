unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CoolTrayIcon, sButton, sEdit, sSkinManager,
  sPanel, acSlider, IniFiles, ComCtrls, acHeaderControl, Buttons, sBitBtn,
  sStatusBar;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label2: TLabel;
    Timer2: TTimer;
    CoolTrayIcon1: TCoolTrayIcon;
    sSkinManager1: TsSkinManager;
    sEdit1: TsEdit;
    sSlider1: TsSlider;
    sButton3: TsButton;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sStatusBar1: TsStatusBar;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure sSlider1SliderChange(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure sEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    function WCenter(wcntr: string): String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  tmpStr : PChar;
  L:Integer;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
var
  HWnd : THandle;
  N : Integer;
begin
 HWnd := GetForeGroundWindow;
 N := GetWindowTextLength(HWnd);
 tmpStr := StrAlloc(N + 1);
 GetWindowText(HWnd, tmpStr, N + 1);
 sEdit1.Text := tmpStr;
 //Label2.Caption := "Длина хэндла" + IntToStr(Length(tmpStr));
 //StrDispose(tmpStr);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
H:HWND;
begin
  H := FindWindow (nil, tmpStr);
    if H<>0 then begin
   SendMessage(H, WM_LBUTTONDOWN, 0, 0);
   SendMessage(H, WM_LBUTTONUP, 0, 0);
   SendMessage(H, WM_SYSCOMMAND, SC_Close, 0);
   Inc(L);
   sStatusBar1.SimpleText:=WCenter('Окно закрыто '+IntToStr(L)+' раз')+'Окно закрыто '+IntToStr(L)+' раз';
   end
   else
end;

procedure TForm1.CoolTrayIcon1Click(Sender: TObject);
begin
CoolTrayIcon1.ShowMainForm;
CoolTrayIcon1.IconVisible:=False;
end;

procedure TForm1.sSlider1SliderChange(Sender: TObject);
begin
  if sSlider1.SliderOn=True then begin
    Timer1.Enabled:=True;
    Timer2.Enabled:=False;
    sEdit1.Enabled:=True;
  end
  else begin
    Timer1.Enabled:=False;
    Timer2.Enabled:=True;
    sEdit1.Enabled:=False;
  end;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
CoolTrayIcon1.ShowBalloonHint('HandleClose', 'Нажмите на иконку чтобы развернуть программу из трея', bitInfo, 11);
CoolTrayIcon1.HideMainForm;
CoolTrayIcon1.IconVisible:=True;
end;

procedure TForm1.sBitBtn1Click(Sender: TObject);
var
  Ini: Tinifile;
begin
Timer1.Enabled:=False;
Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'HandleCloser.ini');
sEdit1.Text:=Ini.ReadString('HandleCloser','Handle',sEdit1.Text);
Ini.Free;
//MessageBox(handle,PChar('Загрузка произведена!'+#13#10), PChar('Информация'), 64);
sStatusBar1.SimpleText:=WCenter('Загрузка произведена!')+'Загрузка произведена!';
tmpStr:=PAnsiChar(sEdit1.Text);
sSlider1.SliderOn:=False;
end;

procedure TForm1.sBitBtn2Click(Sender: TObject);
var
  Ini: Tinifile;
begin
Timer1.Enabled:=False;
Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'HandleCloser.ini');
Ini.WriteString('HandleCloser','Handle',sEdit1.Text);
Ini.Free;
//MessageBox(handle,PChar('Сохранение произведено!'+#13#10), PChar('Информация'), 64);
sStatusBar1.SimpleText:=WCenter('Сохранение произведено!')+'Сохранение произведено!';
if sSlider1.SliderOn=True then Timer1.Enabled:=True;
end;

procedure TForm1.sEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
sEdit1.Hint:=sEdit1.Text;
end;

function TForm1.WCenter(wcntr: string): String;
var
  wc: string;
  ws: Integer;
begin
  ws:=Round((37-(Length(wcntr)))/2);
  repeat
  Insert(' ',wc,ws);
  Dec(ws);
  until ws=0;
  WCenter:=wc;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
L:=0;
end;

end.

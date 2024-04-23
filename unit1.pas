unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Windows, ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

Function GetUserFromWindows: String;
Var UserName: String;
    UserNameLen: dWord;
Begin
   UserNameLen:= 255;
   SetLength(UserName, UserNameLen);
   If GetUserName(PChar(UserName), UserNameLen) Then
     Result:= Copy(UserName, 1, UserNameLen- 1)
   Else
     Result:= 'Unknown';
End;

Function GetComputerNetName: String;
Var buffer: Array[0..255] Of Char;
    Size: dWord;
Begin
  Size:= 256;
  If GetComputerName(Buffer, Size) Then
    Result:= Buffer
  Else
    Result:= 'Undetected';
End;

Function RunAsAdmin(const Handle: Windows.Hwnd; const Path, Params: string): Boolean;
Var sei: ShellApi.TShellExecuteInfoA;
Begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.Wnd := Handle;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT Or SEE_MASK_FLAG_NO_UI Or SEE_MASK_WAITFORINPUTIDLE;
  sei.lpVerb := 'runas';
  sei.lpFile := PAnsiChar(Path);
  sei.lpParameters := PAnsiChar(Params);
  sei.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteExA(@sei);
End;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If RadioButton3.Checked Then
    RunAsAdmin(Form1.Handle, 'cmd', '/k net localgroup administrators '+ Edit1.Text+ ' /add')
  Else
    RunAsAdmin(Form1.Handle, 'cmd', '/k net localgroup administrators '+ Edit1.Text+ ' /delete');
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Button1.Enabled:= Length(Edit1.Text)> 3;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  Edit1.Text:= GetUserFromWindows;
  Edit1.ReadOnly:= True;
  Edit1.Color:= clBtnFace;
  Button1.Enabled:= Edit1.Text<> 'Unknown';
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  Edit1.Text:= '';
  Edit1.ReadOnly:= False;
  Edit1.Color:= clDefault;
end;

end.


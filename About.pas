 unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, jpeg, ShellAPI;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    btExit: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Comments: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure btExitClick(Sender: TObject);
  private
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmAbout := nil;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
//  Label3.Caption := frmRegistration.edRegKey.Text;
end;

procedure TfrmAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','mailto:blind@ngs.ru',nil,nil,0);
end;

procedure TfrmAbout.btExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams (Params);
end;

end.


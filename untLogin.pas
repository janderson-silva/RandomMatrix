unit untLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmLogin = class(TForm)
    Panel1: TPanel;
    pnlLogin: TPanel;
    Label1: TLabel;
    edtCodigoAcesso: TEdit;
    procedure pnlLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.pnlLoginClick(Sender: TObject);
const
  CodigoAcessoCorreto = 'MercurioGerador'; // Código de acesso correto (substitua pelo desejado)
var
  CodigoDigitado: string;
begin
  CodigoDigitado := edtCodigoAcesso.Text;

  if CodigoDigitado = CodigoAcessoCorreto then
    ModalResult := mrOk
  else
  begin
    ShowMessage('Código de acesso incorreto. Tente novamente.');
    edtCodigoAcesso.SetFocus;
    edtCodigoAcesso.SelectAll;
  end;
end;

end.

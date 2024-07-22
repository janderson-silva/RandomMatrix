unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, System.Generics.Collections;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    FDMemTable1: TFDMemTable;
    pnlGerar: TPanel;
    spnQtdReg: TSpinEdit;
    Label1: TLabel;
    DataSource1: TDataSource;
    spnValueMin: TSpinEdit;
    Label2: TLabel;
    spnValueMax: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    spnQtdColuna: TSpinEdit;
    procedure pnlGerarClick(Sender: TObject);
  private
    { Private declarations }
    procedure CriarCamposMemTable;
    procedure GenerateRandomNumbersNew;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmPrincipal.CriarCamposMemTable;
var
  I: Integer;
  Campo: TField;
begin
  // Limpar campos existentes (opcional)
  FDMemTable1.Close;
  FDMemTable1.FieldDefs.Clear;

  // Criar os campos de acordo com a quantidade informada
  for I := 1 to spnQtdColuna.Value do
  begin
    // Adicionar o campo à lista de campos do MemTable
    FDMemTable1.FieldDefs.Add('seq_' + I.ToString,
                              ftString,
                              2,
                              False );
  end;

  // Definir a estrutura da tabela em memória
  FDMemTable1.CreateDataSet;

  //mudar o nome dos campos ja criados
  for I := 0 to FDMemTable1.FieldCount - 1 do
  begin
    //mudar o nome dos campos
    FDMemTable1.Fields[I].DisplayLabel := (I + 1).ToString + '°';
    FDMemTable1.Fields[I].DisplayWidth := 5;
    FDMemTable1.Fields[I].Alignment    := taCenter;
  end;
end;

procedure TfrmPrincipal.GenerateRandomNumbersNew;
var
  MinValue: Integer;
  MaxValue: Integer;
  I, J: Integer;
  Numbers: TList<Integer>;
  RandomNumber: Integer;
  UsedNumbers: TDictionary<Integer, Boolean>;
  NumLines: Integer;
  NumColumns: Integer;
begin
  // Certifique-se de que o dataset está vazio antes de preenchê-lo
  FDMemTable1.EmptyDataSet;

  MinValue := spnValueMin.Value;
  MaxValue := spnValueMax.Value;
  NumLines := spnQtdReg.Value;
  NumColumns := FDMemTable1.FieldCount; // Número de colunas no FDMemTable

  // Verifica se o intervalo de valores é grande o suficiente para o número de números únicos
  if (MaxValue - MinValue + 1) < NumColumns then
  begin
    ShowMessage('O intervalo de números é menor do que o número de colunas.');
    Exit;
  end;

  // Cria uma lista para armazenar os números e um dicionário para rastrear números usados
  Numbers := TList<Integer>.Create;
  UsedNumbers := TDictionary<Integer, Boolean>.Create;

  try
    Randomize;

    // Gera números únicos aleatórios para cada linha
    for I := 0 to NumLines - 1 do
    begin
      Numbers.Clear;
      UsedNumbers.Clear; // Limpa o dicionário a cada nova linha

      while Numbers.Count < NumColumns do
      begin
        RandomNumber := Random(MaxValue - MinValue + 1) + MinValue;

        if not UsedNumbers.ContainsKey(RandomNumber) then
        begin
          UsedNumbers.Add(RandomNumber, True);
          Numbers.Add(RandomNumber);
        end;
      end;

      // Adiciona uma nova linha ao FDMemTable
      FDMemTable1.Append;

      // Preenche as colunas com os números gerados
      for J := 0 to Numbers.Count - 1 do
      begin
        if J < FDMemTable1.FieldCount then
          FDMemTable1.Fields[J].AsString := Format('%2.2d',[Numbers[J]]);
      end;

      FDMemTable1.Post;
    end;
  finally
    Numbers.Free;
    UsedNumbers.Free;
  end;
end;

procedure TfrmPrincipal.pnlGerarClick(Sender: TObject);
begin
  CriarCamposMemTable;
  GenerateRandomNumbersNew;
end;

end.

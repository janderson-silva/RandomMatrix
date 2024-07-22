unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, System.Generics.Collections, Xml.XMLDoc, Xml.XMLIntf,
  ComObj, DataSet.Serialize, System.JSON, Vcl.CheckLst;

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
    Panel2: TPanel;
    pnlExportarXML: TPanel;
    pnlExportarCSV: TPanel;
    pnlExportarJSON: TPanel;
    procedure pnlGerarClick(Sender: TObject);
    procedure pnlExportarCSVClick(Sender: TObject);
    procedure pnlExportarJSONClick(Sender: TObject);
    procedure pnlExportarXMLClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    procedure CriarCamposMemTable;
    procedure GenerateRandomNumbersNew;

    procedure ExportarParaXLS(memTable: TFDMemTable; const arquivoCSV: string);
    procedure ExportarParaJSON(memTable: TFDMemTable; const arquivoJSON: string);
    procedure ExportarParaXML(memTable: TFDMemTable; const arquivoXML: string);
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

  // Criar campo para checkbox (marcado ou não)
  FDMemTable1.FieldDefs.Add('Utilizado', ftBoolean);

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

  // Mudar o nome dos campos já criados
  for I := 0 to FDMemTable1.FieldCount - 1 do
  begin
    if I = 0 then
    begin
      FDMemTable1.Fields[I].DisplayLabel := 'Utilizado';
      FDMemTable1.Fields[I].Alignment    := taCenter;
    end
    else
    begin
      FDMemTable1.Fields[I].DisplayLabel := (I).ToString + '°';
      FDMemTable1.Fields[I].DisplayWidth := 5;
      FDMemTable1.Fields[I].Alignment    := taCenter;
    end;
  end;
end;

procedure TfrmPrincipal.ExportarParaXLS(memTable: TFDMemTable;
  const arquivoCSV: string);
var
  ExcApp: OleVariant;
  i,l: integer;
begin
  ExcApp := CreateOleObject('Excel.Application');
  ExcApp.Visible := True;
  ExcApp.WorkBooks.Add;
  memTable.First;
  l := 1;
  memTable.First;
  while not memTable.EOF do
  begin
    for i := 0 to memTable.Fields.Count - 1 do
      ExcApp.WorkBooks[1].Sheets[1].Cells[l,i + 1] :=
        memTable.Fields[i].DisplayText;
    memTable.Next;
    l := l + 1;
  end;
  ExcApp.WorkBooks[1].SaveAs(arquivoCSV);
end;

procedure TfrmPrincipal.DBGrid1CellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Utilizado' then
  begin
    FDMemTable1.Edit;
    FDMemTable1.FieldByName('Utilizado').AsBoolean := not FDMemTable1.FieldByName('Utilizado').AsBoolean;
    FDMemTable1.Post;
  end;
end;

procedure TfrmPrincipal.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  CheckBoxRect: TRect;
  CheckBoxState: TCheckBoxState;
  CheckBoxSize: Integer;
  CheckBoxLeft: Integer;
begin
  if FDMemTable1.IsEmpty then
    Exit;

  case FDMemTable1.FieldByName('Utilizado').AsBoolean of
    True: Dbgrid1.Canvas.Brush.Color:= clGreen;
    False: Dbgrid1.Canvas.Brush.Color:= clRed;
  end;
  Dbgrid1.Canvas.Font.Style := [fsBold];
  Dbgrid1.Canvas.FillRect(Rect);
  Dbgrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  // Verifica se está desenhando a coluna do campo Utilizado
  if Column.Field.FieldName = 'Utilizado' then
  begin
    // Calcula o tamanho do CheckBox
    CheckBoxSize := 14; // Tamanho padrão de um CheckBox

    // Calcula a posição do CheckBox na célula
    CheckBoxLeft := Rect.Left + (Rect.Width - CheckBoxSize) div 2;

    // Define o retângulo para o CheckBox
    CheckBoxRect := Rect;
    CheckBoxRect.Left := CheckBoxLeft;
    CheckBoxRect.Right := CheckBoxRect.Left + CheckBoxSize;

    // Desenha o fundo da célula
    DBGrid1.Canvas.FillRect(Rect);

    // Desenha o CheckBox baseado no valor do campo Utilizado
    if Column.Field.AsBoolean then
      CheckBoxState := cbChecked
    else
      CheckBoxState := cbUnchecked;

    DrawFrameControl(DBGrid1.Canvas.Handle, CheckBoxRect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED * Ord(Column.Field.AsBoolean));
  end;
end;

procedure TfrmPrincipal.ExportarParaJSON(memTable: TFDMemTable;
  const arquivoJSON: string);
var
  LJSONArray: TJSONArray;
  Arquivo: TStringList;
begin
  LJSONArray := memTable.ToJSONArray;
  Arquivo := TStringList.Create;
  try
    Arquivo.Add(LJSONArray.Format);
    Arquivo.SaveToFile(arquivoJSON);
  finally
    LJSONArray.Free;
    Arquivo.Free;
  end;
end;

procedure TfrmPrincipal.ExportarParaXML(memTable: TFDMemTable;
  const arquivoXML: string);
var
  xmlDoc: IXMLDocument;
  root, rowNode, fieldNode: IXMLNode;
  i: Integer;
begin
  xmlDoc := TXMLDocument.Create(nil);
  xmlDoc.Active := True;

  root := xmlDoc.AddChild('Data');
  memTable.First;
  while not memTable.Eof do
  begin
    rowNode := root.AddChild('Row');
    for i := 0 to memTable.FieldCount - 1 do
    begin
      fieldNode := rowNode.AddChild(memTable.Fields[i].FieldName);
      fieldNode.Text := memTable.Fields[i].AsString;
    end;
    memTable.Next;
  end;

  xmlDoc.SaveToFile(arquivoXML);
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

      while Numbers.Count < NumColumns - 1 do // Menos 1 para o campo de checkbox
      begin
        RandomNumber := Random(MaxValue - MinValue + 1) + MinValue;

        if not UsedNumbers.ContainsKey(RandomNumber) then
        begin
          UsedNumbers.Add(RandomNumber, True);
          Numbers.Add(RandomNumber);
        end;
      end;

      // Ordena os números gerados para esta linha
      Numbers.Sort;

      // Adiciona uma nova linha ao FDMemTable
      FDMemTable1.Append;

      // Preenche as colunas com os números ordenados gerados
      for J := 0 to Numbers.Count - 1 do
      begin
        if J < FDMemTable1.FieldCount - 1 then // Ignorar o último campo (checkbox)
          FDMemTable1.Fields[J + 1].AsString := Format('%2.2d', [Numbers[J]]);
      end;

      // Define o campo de checkbox como não utilizado
      FDMemTable1.FieldByName('Utilizado').AsBoolean := False;

      FDMemTable1.Post;
    end;
  finally
    Numbers.Free;
    UsedNumbers.Free;
  end;
end;


procedure TfrmPrincipal.pnlExportarXMLClick(Sender: TObject);
begin
  ExportarParaXML(FDMemTable1, GetCurrentDir+'\numeros.xml');
  ShowMessage('Exportação concluída!');
end;

procedure TfrmPrincipal.pnlExportarCSVClick(Sender: TObject);
begin
  ExportarParaXLS(FDMemTable1, GetCurrentDir+'\numeros.xls');
  ShowMessage('Exportação concluída!');
end;

procedure TfrmPrincipal.pnlExportarJSONClick(Sender: TObject);
begin
  ExportarParaJSON(FDMemTable1, GetCurrentDir+'\numeros.json');
  ShowMessage('Exportação concluída!');
end;

procedure TfrmPrincipal.pnlGerarClick(Sender: TObject);
begin
  CriarCamposMemTable;
  GenerateRandomNumbersNew;
end;

end.

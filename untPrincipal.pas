unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, System.Generics.Collections, Xml.XMLDoc, Xml.XMLIntf,
  ComObj, DataSet.Serialize, System.JSON, Vcl.CheckLst, DataSet.Serialize.Config;

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
    pnlImportar: TPanel;
    OpenDialog1: TOpenDialog;
    procedure pnlGerarClick(Sender: TObject);
    procedure pnlExportarCSVClick(Sender: TObject);
    procedure pnlExportarJSONClick(Sender: TObject);
    procedure pnlExportarXMLClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure pnlImportarClick(Sender: TObject);
  private
    { Private declarations }
    procedure CriarCamposMemTable;
    procedure AlterarDisplayCamposMemTable;
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

uses
  untLogin;

{$R *.dfm}

{ TForm1 }

procedure TfrmPrincipal.AlterarDisplayCamposMemTable;
var
  I: Integer;
begin
  // Mudar o nome dos campos j� criados
  for I := 0 to FDMemTable1.FieldCount - 1 do
  begin
    if I = 0 then
    begin
      FDMemTable1.Fields[I].DisplayLabel := 'Utilizado';
      FDMemTable1.Fields[I].Alignment    := taCenter;
    end
    else
    begin
      FDMemTable1.Fields[I].DisplayLabel := (I).ToString + '�';
      FDMemTable1.Fields[I].DisplayWidth := 5;
      FDMemTable1.Fields[I].Alignment    := taCenter;
    end;
  end;
end;

procedure TfrmPrincipal.CriarCamposMemTable;
var
  I: Integer;
  Campo: TField;
begin
  // Limpar campos existentes (opcional)
  FDMemTable1.Close;
  FDMemTable1.FieldDefs.Clear;

  // Criar campo para checkbox (marcado ou n�o)
  FDMemTable1.FieldDefs.Add('Utilizado', ftBoolean);

  // Criar os campos de acordo com a quantidade informada
  for I := 1 to spnQtdColuna.Value do
  begin
    // Adicionar o campo � lista de campos do MemTable
    FDMemTable1.FieldDefs.Add('seq_' + I.ToString,
                              ftString,
                              2,
                              False );
  end;

  // Definir a estrutura da tabela em mem�ria
  FDMemTable1.CreateDataSet;

  AlterarDisplayCamposMemTable;
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

  // Verifica se est� desenhando a coluna do campo Utilizado
  if Column.Field.FieldName = 'Utilizado' then
  begin
    // Calcula o tamanho do CheckBox
    CheckBoxSize := 14; // Tamanho padr�o de um CheckBox

    // Calcula a posi��o do CheckBox na c�lula
    CheckBoxLeft := Rect.Left + (Rect.Width - CheckBoxSize) div 2;

    // Define o ret�ngulo para o CheckBox
    CheckBoxRect := Rect;
    CheckBoxRect.Left := CheckBoxLeft;
    CheckBoxRect.Right := CheckBoxRect.Left + CheckBoxSize;

    // Desenha o fundo da c�lula
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

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  FormAcesso: TfrmLogin;
begin
  FormAcesso := TfrmLogin.Create(nil);
  try
    if FormAcesso.ShowModal <> mrOk then
      Application.Terminate; // Fecha a aplica��o se o c�digo de acesso n�o for correto
  finally
    FormAcesso.Free;
  end;

  //configura��es do dataset.serialize para apresentar os campos de maneira correta
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
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
  // Certifique-se de que o dataset est� vazio antes de preench�-lo
  FDMemTable1.EmptyDataSet;

  MinValue := spnValueMin.Value;
  MaxValue := spnValueMax.Value;
  NumLines := spnQtdReg.Value;
  NumColumns := FDMemTable1.FieldCount; // N�mero de colunas no FDMemTable

  // Verifica se o intervalo de valores � grande o suficiente para o n�mero de n�meros �nicos
  if (MaxValue - MinValue + 1) < NumColumns then
  begin
    ShowMessage('O intervalo de n�meros � menor do que o n�mero de colunas.');
    Exit;
  end;

  // Cria uma lista para armazenar os n�meros e um dicion�rio para rastrear n�meros usados
  Numbers := TList<Integer>.Create;
  UsedNumbers := TDictionary<Integer, Boolean>.Create;

  try
    Randomize;

    // Gera n�meros �nicos aleat�rios para cada linha
    for I := 0 to NumLines - 1 do
    begin
      Numbers.Clear;
      UsedNumbers.Clear; // Limpa o dicion�rio a cada nova linha

      while Numbers.Count < NumColumns - 1 do // Menos 1 para o campo de checkbox
      begin
        RandomNumber := Random(MaxValue - MinValue + 1) + MinValue;

        if not UsedNumbers.ContainsKey(RandomNumber) then
        begin
          UsedNumbers.Add(RandomNumber, True);
          Numbers.Add(RandomNumber);
        end;
      end;

      // Ordena os n�meros gerados para esta linha
      Numbers.Sort;

      // Adiciona uma nova linha ao FDMemTable
      FDMemTable1.Append;

      // Preenche as colunas com os n�meros ordenados gerados
      for J := 0 to Numbers.Count - 1 do
      begin
        if J < FDMemTable1.FieldCount - 1 then // Ignorar o �ltimo campo (checkbox)
          FDMemTable1.Fields[J + 1].AsString := Format('%2.2d', [Numbers[J]]);
      end;

      // Define o campo de checkbox como n�o utilizado
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
  ShowMessage('Exporta��o conclu�da!');
end;

procedure TfrmPrincipal.pnlExportarCSVClick(Sender: TObject);
begin
  ExportarParaXLS(FDMemTable1, GetCurrentDir+'\numeros.xls');
  ShowMessage('Exporta��o conclu�da!');
end;

procedure TfrmPrincipal.pnlExportarJSONClick(Sender: TObject);
begin
  ExportarParaJSON(FDMemTable1, GetCurrentDir+'\numeros.json');
  ShowMessage('Exporta��o conclu�da!');
end;

procedure TfrmPrincipal.pnlGerarClick(Sender: TObject);
begin
  CriarCamposMemTable;
  GenerateRandomNumbersNew;
end;

procedure TfrmPrincipal.pnlImportarClick(Sender: TObject);
var
  Arquivo: TStringList;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  JSONValue: TJSONValue;
  I, J: Integer;
  FieldName: string;
begin
  OpenDialog1.FileName := '';
  if OpenDialog1.Execute then
    if OpenDialog1.FileName <> '' then
    begin
      Arquivo := TStringList.Create;
      try
        Arquivo.LoadFromFile(OpenDialog1.FileName);
        if Trim(Arquivo.Text) <> '' then
        begin
          FDMemTable1.Close;

          // Carrega o JSON
          JSONValue := TJSONObject.ParseJSONValue(Arquivo.Text);
          if JSONValue is TJSONArray then
          begin
            JSONArray := JSONValue as TJSONArray;

            // Limpa os campos existentes
            FDMemTable1.FieldDefs.Clear;

            // Adiciona o campo 'Utilizado'
            FDMemTable1.FieldDefs.Add('Utilizado', ftBoolean);

            // Adiciona os campos sequenciais do JSON
            if JSONArray.Count > 0 then
            begin
              JSONObject := JSONArray.Items[0] as TJSONObject;

              // Itera sobre as chaves do primeiro item para adicionar os campos
              for I := 0 to JSONObject.Size - 1 do
              begin
                FieldName := JSONObject.Pairs[I].JsonString.Value;

                // Adiciona o campo se n�o for 'Utilizado'
                if FieldName <> 'utilizado' then
                  FDMemTable1.FieldDefs.Add(FieldName, ftString, 2, False);
              end;
            end;

            FDMemTable1.CreateDataSet;

            // Carrega os dados do JSON para o TFDMemTable
            for I := 0 to JSONArray.Count - 1 do
            begin
              JSONObject := JSONArray.Items[I] as TJSONObject;

              FDMemTable1.Append;
              for J := 0 to JSONObject.Size - 1 do
              begin
                FieldName := JSONObject.Pairs[J].JsonString.Value;
                if FieldName = 'utilizado' then
                  FDMemTable1.FieldByName('Utilizado').AsBoolean :=
                    JSONObject.Pairs[J].JsonValue.Value.ToBoolean
                else
                  FDMemTable1.FieldByName(FieldName).AsString :=
                    JSONObject.Pairs[J].JsonValue.Value;
              end;
              FDMemTable1.Post;
            end;

            // Altera o display dos campos
            AlterarDisplayCamposMemTable;

            // Abre o FDMemTable1
            FDMemTable1.Open;
          end;
        end;
      finally
        Arquivo.Free;
      end;
    end;
end;

end.

# Gerador de Números Aleatórios com Exportação (Delphi)

Este projeto Delphi gera registros com números aleatórios, permite visualização e exportação em formatos CSV, XML e JSON. Também é possível importar um arquivo JSON para popular os dados na tabela em memória.

## Funcionalidades

✅ Geração de registros aleatórios com múltiplas colunas  
✅ Marcação de registros como "Utilizado" com checkbox  
✅ Exportação para:
- 📁 XML
- 📁 CSV (XLS - usando Excel via OLE Automation)
- 📁 JSON

✅ Importação de arquivos `.json`  
✅ Visualização com cores personalizadas no `TDBGrid`  
✅ Tela de login simples no início da aplicação

## Componentes Utilizados

- `TFDMemTable`, `TDBGrid`, `TSpinEdit`, `TOpenDialog`
- `TPanel`, `TLabel`, `TForm`, `TCheckListBox`
- Serialização com `DataSet.Serialize`

## Estrutura do Código

- **Geração de dados:**  
  - `CriarCamposMemTable`: Cria campos dinamicamente baseado em `spnQtdColuna`  
  - `GenerateRandomNumbersNew`: Gera números únicos por linha, com marcação "Utilizado"

- **Exportação:**  
  - `ExportarParaXML`, `ExportarParaJSON`, `ExportarParaXLS`  
  - Os arquivos são salvos na pasta do executável (`numeros.xml`, `numeros.json`, `numeros.xls`)

- **Importação:**  
  - Lê arquivo `.json`, recria campos e importa dados no `TFDMemTable`

## Observações

- A exportação CSV usa automação do Excel (`CreateOleObject('Excel.Application')`), exigindo que o Excel esteja instalado.
- O campo booleano "Utilizado" é destacado com cores no grid (verde para usado, vermelho para não usado).
- O campo "Utilizado" é clicável diretamente no `TDBGrid`.

## Requisitos

- Delphi com FireDAC e DataSet.Serialize instalados
- Excel instalado (para exportação XLS)
- Compatível com VCL Windows

## Créditos

Autor: Janderson Silva  
Dependência externa: [DataSet.Serialize](https://github.com/viniciussanchez/dataset-serialize)

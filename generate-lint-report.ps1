# Função para ler o log e agrupar os erros
function ProcessLintLog {
    param (
        [string]$logFilePath
    )

    $errorTypes = @{}

    # Ler o arquivo de log linha por linha
    Get-Content $logFilePath | ForEach-Object {
        # Verificar se a linha contém um erro
        if ($_ -match '^ERROR: .+ - (.+)') {
            $errorMessage = $Matches[1]
            if ($errorTypes.ContainsKey($errorMessage)) {
                $errorTypes[$errorMessage]++
            } else {
                $errorTypes[$errorMessage] = 1
            }
        }
    }

    return $errorTypes
}

# Função para gerar o relatório HTML
function GenerateHTMLReport {
    param (
        [hashtable]$errorTypes
    )

    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Relatório de Erros de Lint</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Relatório de Erros de Lint</h2>
    <table>
        <tr>
            <th>Tipo de Erro</th>
            <th>Quantidade</th>
        </tr>
"@

    # Adicionar linhas para cada tipo de erro
    foreach ($errorType in $errorTypes.GetEnumerator() | Sort-Object Name) {
        $html += "<tr><td>$($errorType.Key)</td><td>$($errorType.Value)</td></tr>"
    }

    $html += @"
    </table>
</body>
</html>
"@

    return $html
}

# Caminho do arquivo de log
$logFilePath = "C:\caminho\para\o\arquivo\lint.log"

# Processar o log e obter tipos de erro e quantidades
$errorTypes = ProcessLintLog -logFilePath $logFilePath

# Gerar o relatório HTML
$htmlReport = GenerateHTMLReport -errorTypes $errorTypes

# Salvar o relatório HTML em um arquivo
$htmlReportFilePath = "C:\caminho\para\o\arquivo\relatorio.html"
$htmlReport | Out-File -FilePath $htmlReportFilePath -Encoding UTF8

Write-Host "Relatório HTML gerado em: $htmlReportFilePath"

<#
.SYNOPSIS
  Consulta issues do SonarQube para um Pull Request do GitHub no Windows.

.USO
  .\sonar-pr-issues.ps1 -PrUrl "https://github.com/org/repo/pull/42"
  # Ou com parâmetro posicional:
  .\sonar-pr-issues.ps1 "https://github.com/org/repo/pull/42"
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$PrUrl
)

# Validar variáveis de ambiente
$required = @('SONAR_URL', 'SONAR_TOKEN', 'PROJECT_KEY')
foreach ($var in $required) {
    if (-not $env:$var) {
        Write-Error "❌ Variável de ambiente não definida: $var"
        exit 1
    }
}

# Extrair número do PR da URL
if ($PrUrl -match 'pull/(\d+)') {
    $prNum = $matches[1]
} else {
    Write-Error "❌ URL do PR inválida. Use formato: https://github.com/org/repo/pull/NN"
    exit 1
}

Write-Host "🔍 Buscando issues do SonarQube para PR #$prNum ($env:PROJECT_KEY)..." -ForegroundColor Cyan
Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray

$page = 1
$total = 1
$baseUrl = "$env:SONAR_URL/api/issues/search"

while ($page -le $total) {
    $uri = "$baseUrl?pullRequest=$prNum&componentKeys=$env:PROJECT_KEY&resolved=false&ps=500&p=$page&s=FILE_LINE"
    
    try {
        $response = Invoke-RestMethod -Uri $uri -Headers @{
            Authorization = "Bearer $env:SONAR_TOKEN"
        } -ContentType "application/json" -ErrorAction Stop
        
        $total = $response.paging.total
        
        if ($response.issues) {
            foreach ($issue in $response.issues) {
                $component = $issue.component -replace "^$env:PROJECT_KEY:", ""
                $line = if ($issue.line) { ":$($issue.line)" } else { "" }
                $severity = $issue.severity.PadRight(8)
                $type = $issue.type.PadRight(12)
                
                Write-Host "$severity $type $($component)$line`t$($issue.message)"
            }
        }
        
        $page++
    }
    catch {
        Write-Error "❌ Erro na API: $($_.Exception.Message)"
        exit 1
    }
}

if ($total -eq 0) {
    Write-Host "✅ Nenhuma issue aberta encontrada para este PR!" -ForegroundColor Green
} else {
    Write-Host "✅ Fim da listagem ($total issues no total)." -ForegroundColor Green
}
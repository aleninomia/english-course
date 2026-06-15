@echo off
setlocal EnableDelayedExpansion

:: Validar variáveis
if not defined SONAR_URL (echo ❌ SONAR_URL nao definida & exit /b 1)
if not defined SONAR_TOKEN (echo ❌ SONAR_TOKEN nao definida & exit /b 1)
if not defined PROJECT_KEY (echo ❌ PROJECT_KEY nao definida & exit /b 1)

:: Extrair numero do PR
set "PR_URL=%~1"
set "PR_NUM="
for /f "tokens=* delims=" %%a in ('powershell -NoProfile -Command "$m=[regex]::Match('%PR_URL%','pull/(\d+)'); if($m.Success){$m.Groups[1].Value}"') do set "PR_NUM=%%a"

if not defined PR_NUM (echo ❌ URL invalida & exit /b 1)

echo 🔍 Buscando issues para PR #%PR_NUM%...
echo ---------------------------------------------------------

:: Chamada simples à API (sem paginação automática no batch puro)
curl.exe -s -u "%SONAR_TOKEN%:" "%SONAR_URL%/api/issues/search?pullRequest=%PR_NUM%^&componentKeys=%PROJECT_KEY%^&resolved=false^&ps=100^&s=FILE_LINE" > temp_sonar.json

:: Processar com jq (precisa estar instalado: https://stedolan.github.io/jq/download/)
if not exist jq.exe (echo ⚠️ jq nao encontrado. Baixe em https://stedolan.github.io/jq/download/ & exit /b 1)

jq -r ".issues[] | \"\(.severity)\t\(.type)\t\(.component)\(.line)\t\(.message)\"" temp_sonar.json 2>nul | findstr /v "^$"

del temp_sonar.json
echo ✅ Fim.
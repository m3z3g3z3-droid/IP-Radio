# Pergunta a tag
$tag = Read-Host "Digite o termo da pesquisa (ex: rock, metal, jazz)"
if (-not $tag) { $tag = "study" }

# URL da API (sem limite)
$url = "https://de1.api.radio-browser.info/json/stations/search?tag=$tag&order=votes"

# Busca radios
$radios = Invoke-RestMethod $url

if ($radios.Count -eq 0) {
    Write-Host "Nenhuma radio encontrada"
    exit
}

# Lista radios numeradas
$i = 0
$radios | ForEach-Object {
    Write-Host "===================================="
    Write-Host "[$i] Nome:   $($_.name)"
    Write-Host "    Pais:   $($_.country)"
    Write-Host "    Votos:  $($_.votes)"
    Write-Host "    Codec:  $($_.codec)"
    Write-Host "    ICY:    $(
        if ($_.has_extended_info) { 'SIM' } else { 'NAO' }
    )"
    Write-Host "    $($_.url_resolved)"
    $i++
}

# Escolha da radio
$sel = [int](Read-Host "Digite o numero da radio para tocar")

# Validacao correta
if ($sel -lt 0 -or $sel -ge $radios.Count) {
    Write-Host "Numero invalido"
    exit
}



# Toca no mpv
Write-Host "Tocando: $($radios[$sel].name)"
mpv $radios[$sel].url_resolved

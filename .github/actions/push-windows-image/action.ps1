Param(
    [Parameter(Mandatory=$true)]
    [string[]]
    $image,
    [Parameter(Mandatory=$true)]
    [ValidateSet('2017', '2019', '2022')]
    [string[]]
    $vs
)

Push-Location "$PSScriptRoot"

./images/vs_version_matrix.ps1

# Push baseline image
docker push $image

$clList = $vsVersionMatrix["$vs"]
foreach($cl in $clList) {
    # Concatenate compiler version to image and push
    docker push $image-$cl
}

Pop-Location
Option Explicit
Sub Main
Dim nu As Integer

nu=0

Const d As Double=360
Const nn As Integer=11
Dim x As Double
Dim y As Double

Dim sta(300) As Integer
Dim i, m,n,k As Integer
Dim j As Integer
Dim tmpa, tmpb As String, contents As String
Dim ty As Integer
m=1
n=1
i=1
j=1
	Open "D:\off-axis\x01,1,x02,2,xl1,xl2,3.5,nu1,nu2,1\alphari.txt" For Input As #1
	While EOF(1) = 0
        Line Input #1,tmpa
	'contents = contents + tmpa
	sta(m)=CInt(tmpa)
m=m+1
Wend

m=1
For i=1 To 150


x=(i-150/2)*d

With Rotate
nu=nu+1
n=i+150

    .Reset
    .Name ("c_" & nu)
    .Component ("component1")
    .Material ("Silicon (loss free)")
    .Mode ("pointlist")
    .StartAngle (180-sta(m)/2)
    .Angle (sta(m))
    .Height (0)
    .RadiusRatio (1)
    .Origin (x,y,0)
    .Rvector ( 1,0,0)
    .Zvector ( 0,0,1)
    .Point ( 140, 200)
    .LineTo ( sta(n), 200 )
    .LineTo ( sta(n), 0 )
    .LineTo ( 140, 0 )
    .LineTo ( 140, 200 )
    .create

End With
m=m+1
Next

End Sub

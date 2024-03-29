Attribute VB_Name = "Module1"
Sub VBA_Homework_Stock_Data():

' Hey, Hello, Hi There - Welcome to my VBA homework :)

' First things first I'm the realeast (Iggy Azalea reference)
' Just kidding, first things first is setting all dimensions for all tables
' (including the new table and challenge table)

    Dim ws As Worksheet
    Dim totalvolume As Double
    Dim x As Long
    Dim change As Long
    Dim y As Long
    Dim start As Long
    Dim rowCount As Long
    Dim percentChange As Double
    Dim days As Long

' Step 2: Create the loop to go through all of the worksheets
    
    For Each ws In Worksheets

' Step 3: the Layout & Formatting - all cosmetic stuff.

' Range for table headers = A1:G1, I1:L1, N1:P1.
' I'd like all headers to be underlined and a light grey colour, to make them stand out from the rest of the data.
' Referenced https://excelchamps.com/vba/borders/

    ws.Range("A1:G1").Borders(xlEdgeBottom).LineStyle = XlLineStyle.xlContinuous
    ws.Range("A1:G1").Interior.ColorIndex = 15
    ws.Range("I1:L1").Borders(xlEdgeBottom).LineStyle = XlLineStyle.xlContinuous
    ws.Range("I1:L1").Interior.ColorIndex = 15
    ws.Range("N1:P1").Borders(xlEdgeBottom).LineStyle = XlLineStyle.xlContinuous
    ws.Range("N1:P1").Interior.ColorIndex = 15
    ws.Range("N1:N4").Interior.ColorIndex = 15
    
' Insert the new headers for the two new tables

    ws.Range("I1").Value = "Ticker"
    ws.Range("J1").Value = "Yearly Change"
    ws.Range("K1").Value = "Percent Change"
    ws.Range("L1").Value = "Total Stock Volume"

    ws.Range("N2").Value = "Greatest % Increase"
    ws.Range("N3").Value = "Greatest % Decrease"
    ws.Range("N4").Value = "Greatest Total Volume"
    ws.Range("O1").Value = "Ticker"
    ws.Range("P1").Value = "Value"

' Autofit all columns to display the data and headers in full
    
    ws.Columns("A:G").AutoFit
    ws.Columns("I:L").AutoFit
    ws.Columns("N:P").AutoFit

' Step 4: Set ALL starting values, for counting and quick mafths

    y = 0
    totalvolume = 0
    change = 0
    start = 2

' Step 5: Control,Shift,Down to create the loop to the last row with data

    rowCount = ws.Cells(Rows.Count, "A").End(xlUp).Row

    For x = 2 To rowCount

' Step 6: Collecting, storing & counting the data associated with the tickers
        
' If the ticker changes, then print the results
' "in the current ws, with i = 2 (after the headers),"
' "if the next cell down in column 1 does not equal the current value in column 1,"
' "then add the data from column G (aka 7) to the total volume"

            If ws.Cells(x + 1, 1).Value <> ws.Cells(x, 1).Value Then

                totalvolume = totalvolume + ws.Cells(x, 7).Value

                'VBA, don't be so dramatic, here's what to do if the TotalVolume is zero.

                If totalvolume = 0 Then
                
                ' print the results
                ws.Range("I" & 2 + y).Value = ws.Cells(x, 1).Value
                ws.Range("J" & 2 + y).Value = 0
                ws.Range("K" & 2 + y).Value = "%" & 0
                ws.Range("L" & 2 + y).Value = 0

                    Else
                    ' keep going till you get to the first value that is not zero to start
                
                        If ws.Cells(start, 3) = 0 Then
                        For find_value = start To x

                            If ws.Cells(find_value, 3).Value <> 0 Then
                            start = find_value



                            Exit For
                        End If
                     Next find_value
                End If

' Quick mafths for the change and percent change data

    change = (ws.Cells(x, 6) - ws.Cells(start, 3))
    percentChange = change / ws.Cells(start, 3)

' Mumma Mia, Here I go again - let's start the next ticker
    
    start = x + 1

'  Add results to the first table and put the numbers in the correct format

    ws.Range("I" & 2 + y).Value = ws.Cells(x, 1).Value
    ws.Range("J" & 2 + y).Value = change
    ws.Range("J" & 2 + y).NumberFormat = "0.00"
    ws.Range("K" & 2 + y).Value = percentChange
    ws.Range("K" & 2 + y).NumberFormat = "0.00%"
    ws.Range("L" & 2 + y).Value = totalvolume

' Condition formatting colours into the yearly change column
' Referenced https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/select-case-statement
                
    Select Case change


        ' If she's giving positive yearly change vibes, give her the green light, honey.

            Case Is > 0
                ws.Range("J" & 2 + y).Interior.ColorIndex = 43

        'If she's giving negative yearly change vibes, slap her with a red flag, Will Smith style.

            Case Is < 0
                ws.Range("J" & 2 + y).Interior.ColorIndex = 3

        'If she's giving nothing, she's getting nothing. Period.

            Case Else
                ws.Range("J" & 2 + y).Interior.ColorIndex = 0
        End Select

        End If

    ' reset variables for new stock ticker

        totalvolume = 0
        change = 0
        y = y + 1
        days = 0

    ' If ticker is still the same add results to the total volume
    
        Else
        totalvolume = totalvolume + ws.Cells(x, 7).Value

        End If

    Next x

'Grab min and max voluemes and store the data
 
    ws.Range("P2") = "%" & WorksheetFunction.Max(ws.Range("K2:K" & rowCount)) * 100
    ws.Range("P3") = "%" & WorksheetFunction.Min(ws.Range("K2:K" & rowCount)) * 100
    ws.Range("P4") = WorksheetFunction.Max(ws.Range("L2:L" & rowCount))

' returns one less because header row not a factor
' Reference class activity Credit Cards

    increase_number = WorksheetFunction.Match(WorksheetFunction.Max(ws.Range("K2:K" & rowCount)), ws.Range("K2:K" & rowCount), 0)
    decrease_number = WorksheetFunction.Match(WorksheetFunction.Min(ws.Range("K2:K" & rowCount)), ws.Range("K2:K" & rowCount), 0)
    volume_number = WorksheetFunction.Match(WorksheetFunction.Max(ws.Range("L2:L" & rowCount)), ws.Range("L2:L" & rowCount), 0)

' populate ticker for total, greatest % of increase and decrease, and greatest total volume
    
    ws.Range("O2") = ws.Cells(increase_number + 1, 9)
    ws.Range("O3") = ws.Cells(decrease_number + 1, 9)
    ws.Range("O4") = ws.Cells(volume_number + 1, 9)

' Step 7: Yeehaw cowboy, let's run this loop on the next worksheet

    Next ws

' I did come across a few errors so I put the script in rice for a little while.

' Honestly though, I am very sorry it's late and I absolutely won't make a habit of this.

End Sub

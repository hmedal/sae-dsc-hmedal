\ Model safety stock
\ LP format - for model browsing. Use MPS format to capture full model detail.
Maximize
  200 meanDemand + [ - 10 meanDemand * stageCost[1]
   - 10 meanDemand * stageCost[2] - 10 meanDemand * stageCost[3]
   - 10 meanDemand * stageCost[4] - 10 meanDemand * stageCost[5]
   - 10 meanDemand * stageCost[6]
   + stageCost[1] * meanDemandTimesStageTime[1]
   + stageCost[2] * meanDemandTimesStageTime[2]
   + stageCost[3] * meanDemandTimesStageTime[3]
   + stageCost[4] * meanDemandTimesStageTime[4]
   + stageCost[5] * meanDemandTimesStageTime[5]
   + stageCost[6] * meanDemandTimesStageTime[6]
   - 4 sqRootnetTime[1] * stdDevDemandTimesCumCost[1]
   - 4 sqRootnetTime[2] * stdDevDemandTimesCumCost[2]
   - 4 sqRootnetTime[3] * stdDevDemandTimesCumCost[3]
   - 4 sqRootnetTime[4] * stdDevDemandTimesCumCost[4]
   - 4 sqRootnetTime[5] * stdDevDemandTimesCumCost[5]
   - 4 sqRootnetTime[6] * stdDevDemandTimesCumCost[6]
   - 2 cumCost[1] * meanDemandTimesStageTime[1]
   - 2 cumCost[2] * meanDemandTimesStageTime[2]
   - 2 cumCost[3] * meanDemandTimesStageTime[3]
   - 2 cumCost[4] * meanDemandTimesStageTime[4]
   - 2 cumCost[5] * meanDemandTimesStageTime[5]
   - 2 cumCost[6] * meanDemandTimesStageTime[6] ] / 2 
Subject To
 StageCostCalc[1]: - 3 optionSelect[1,0] - 9 optionSelect[1,1]
   + stageCost[1] = 0
 StageCostCalc[2]: - 4 optionSelect[2,0] - 4 optionSelect[2,1]
   + stageCost[2] = 0
 StageCostCalc[3]: - optionSelect[3,0] - optionSelect[3,1] + stageCost[3]
   = 0
 StageCostCalc[4]: - 8 optionSelect[4,0] - 3 optionSelect[4,1]
   + stageCost[4] = 0
 StageCostCalc[5]: - 3 optionSelect[5,0] - optionSelect[5,1] + stageCost[5]
   = 0
 StageCostCalc[6]: - 6 optionSelect[6,0] - 7 optionSelect[6,1]
   + stageCost[6] = 0
 StageTimeCalc[1]: - 4 optionSelect[1,0] - 2 optionSelect[1,1]
   + stageTime[1] = 0
 StageTimeCalc[2]: - 4 optionSelect[2,0] - 8 optionSelect[2,1]
   + stageTime[2] = 0
 StageTimeCalc[3]: - 2 optionSelect[3,0] - 5 optionSelect[3,1]
   + stageTime[3] = 0
 StageTimeCalc[4]: - 4 optionSelect[4,0] - 8 optionSelect[4,1]
   + stageTime[4] = 0
 StageTimeCalc[5]: - optionSelect[5,0] - 5 optionSelect[5,1] + stageTime[5]
   = 0
 StageTimeCalc[6]: - 6 optionSelect[6,0] - 9 optionSelect[6,1]
   + stageTime[6] = 0
 calcCumCost[1]: - stageCost[1] + cumCost[1] = 0
 calcCumCost[2]: - stageCost[2] + cumCost[2] = 0
 calcCumCost[4]: - stageCost[4] + cumCost[4] = 0
 calcCumCost[5]: - stageCost[5] + cumCost[5] = 0
 select1-component[1]: - nodeSelect[1] + optionSelect[1,0]
   + optionSelect[1,1] = 0
 select1-component[2]: - nodeSelect[2] + optionSelect[2,0]
   + optionSelect[2,1] = 0
 select1-component[4]: - nodeSelect[4] + optionSelect[4,0]
   + optionSelect[4,1] = 0
 select1-component[5]: - nodeSelect[5] + optionSelect[5,0]
   + optionSelect[5,1] = 0
 select1-other[3]: optionSelect[3,0] + optionSelect[3,1] = 1
 select1-other[6]: optionSelect[6,0] + optionSelect[6,1] = 1
 netFlow[3]: arcSelect[1,3] + arcSelect[2,3] - 2 arcSelect[3,6] = 0
 sumOutFlow[1]: - nodeSelect[1] + arcSelect[1,3] + arcSelect[1,6] = 0
 sumOutFlow[2]: - nodeSelect[2] + arcSelect[2,3] + arcSelect[2,6] = 0
 sumOutFlow[4]: - nodeSelect[4] + arcSelect[4,6] = 0
 sumOutFlow[5]: - nodeSelect[5] + arcSelect[5,6] = 0
 useArcIfNode[1,3]: - nodeSelect[1] + arcSelect[1,3] <= 0
 useArcIfNode[1,6]: - nodeSelect[1] + arcSelect[1,6] <= 0
 useArcIfNode[2,3]: - nodeSelect[2] + arcSelect[2,3] <= 0
 useArcIfNode[2,6]: - nodeSelect[2] + arcSelect[2,6] <= 0
 useArcIfNode[4,6]: - nodeSelect[4] + arcSelect[4,6] <= 0
 useArcIfNode[5,6]: - nodeSelect[5] + arcSelect[5,6] <= 0
 procureNodesInTime[1]: sIn[1] = 0
 procureNodesInTime[2]: sIn[2] = 0
 procureNodesInTime[4]: sIn[4] = 0
 procureNodesInTime[5]: sIn[5] = 0
 NetTimeCalc[1]: - stageTime[1] - sIn[1] + sOut[1] + netTime[1] = 0
 NetTimeCalc[2]: - stageTime[2] - sIn[2] + sOut[2] + netTime[2] = 0
 NetTimeCalc[3]: - stageTime[3] - sIn[3] + sOut[3] + netTime[3] = 0
 NetTimeCalc[4]: - stageTime[4] - sIn[4] + sOut[4] + netTime[4] = 0
 NetTimeCalc[5]: - stageTime[5] - sIn[5] + sOut[5] + netTime[5] = 0
 NetTimeCalc[6]: - stageTime[6] - sIn[6] + sOut[6] + netTime[6] = 0
 meanDemandVar: meanDemand - 18 marketShare[CustomerType1]
   - 16 marketShare[CustomerType2] - 5 marketShare[CustomerType3] = 0
 componentsRequired: nodeSelect[1] + nodeSelect[2] + nodeSelect[4]
   + nodeSelect[5] = 3
 calcCumCost[3]: - stageCost[3] + cumCost[3] + [
   - arcSelect[1,3] * cumCost[1] - arcSelect[2,3] * cumCost[2] ] = 0
 calcCumCost[6]: - stageCost[6] + cumCost[6] + [
   - arcSelect[1,6] * cumCost[1] - arcSelect[2,6] * cumCost[2]
   - arcSelect[3,6] * cumCost[3] - arcSelect[4,6] * cumCost[4]
   - arcSelect[5,6] * cumCost[5] ] = 0
 sInGreater[1,3]: sIn[3] + [ - arcSelect[1,3] * sOut[1] ] >= 0
 sInGreater[1,6]: sIn[6] + [ - arcSelect[1,6] * sOut[1] ] >= 0
 sInGreater[2,3]: sIn[3] + [ - arcSelect[2,3] * sOut[2] ] >= 0
 sInGreater[2,6]: sIn[6] + [ - arcSelect[2,6] * sOut[2] ] >= 0
 sInGreater[3,6]: sIn[6] + [ - arcSelect[3,6] * sOut[3] ] >= 0
 sInGreater[4,6]: sIn[6] + [ - arcSelect[4,6] * sOut[4] ] >= 0
 sInGreater[5,6]: sIn[6] + [ - arcSelect[5,6] * sOut[5] ] >= 0
 SqRootNetTimeCalc[1]: netTime[1] + [ - sqRootnetTime[1] ^2 ] = 0
 SqRootNetTimeCalc[2]: netTime[2] + [ - sqRootnetTime[2] ^2 ] = 0
 SqRootNetTimeCalc[3]: netTime[3] + [ - sqRootnetTime[3] ^2 ] = 0
 SqRootNetTimeCalc[4]: netTime[4] + [ - sqRootnetTime[4] ^2 ] = 0
 SqRootNetTimeCalc[5]: netTime[5] + [ - sqRootnetTime[5] ^2 ] = 0
 SqRootNetTimeCalc[6]: netTime[6] + [ - sqRootnetTime[6] ^2 ] = 0
 stdDevDemandTimesCumCostVar[1]: stdDevDemandTimesCumCost[1] + [
   - stdDevDemand * cumCost[1] ] = 0
 stdDevDemandTimesCumCostVar[2]: stdDevDemandTimesCumCost[2] + [
   - stdDevDemand * cumCost[2] ] = 0
 stdDevDemandTimesCumCostVar[3]: stdDevDemandTimesCumCost[3] + [
   - stdDevDemand * cumCost[3] ] = 0
 stdDevDemandTimesCumCostVar[4]: stdDevDemandTimesCumCost[4] + [
   - stdDevDemand * cumCost[4] ] = 0
 stdDevDemandTimesCumCostVar[5]: stdDevDemandTimesCumCost[5] + [
   - stdDevDemand * cumCost[5] ] = 0
 stdDevDemandTimesCumCostVar[6]: stdDevDemandTimesCumCost[6] + [
   - stdDevDemand * cumCost[6] ] = 0
 meanDemandTimesStageTimeVar[1]: meanDemandTimesStageTime[1] + [
   - meanDemand * stageTime[1] ] = 0
 meanDemandTimesStageTimeVar[2]: meanDemandTimesStageTime[2] + [
   - meanDemand * stageTime[2] ] = 0
 meanDemandTimesStageTimeVar[3]: meanDemandTimesStageTime[3] + [
   - meanDemand * stageTime[3] ] = 0
 meanDemandTimesStageTimeVar[4]: meanDemandTimesStageTime[4] + [
   - meanDemand * stageTime[4] ] = 0
 meanDemandTimesStageTimeVar[5]: meanDemandTimesStageTime[5] + [
   - meanDemand * stageTime[5] ] = 0
 meanDemandTimesStageTimeVar[6]: meanDemandTimesStageTime[6] + [
   - meanDemand * stageTime[6] ] = 0
 stdDevDemandVar: [ stdDevDemand ^2 - 9 marketShare[CustomerType1] ^2
   - 9 marketShare[CustomerType2] ^2 - 9 marketShare[CustomerType3] ^2 ]
   <= 0
 customerUtilCalc[CustomerType1]: - 0.07353441 objValVar[0]
   - 0.23812319 objValVar[1] - 0.88198825 objValVar[2]
   - 0.18071148 objValVar[3] - 0.1822069 objValVar[4]
   - 0.86919866 objValVar[5] - 0.12726251 objValVar[6]
   - 0.86094461 objValVar[7] - 0.06614307 objValVar[8]
   - 0.12788772 objValVar[9] - 0.65358829 objValVar[10] + [
   customerUtil[CustomerType1] ^2 ] <= 0
 customerUtilCalc[CustomerType2]: - 0.06854985 objValVar[0]
   - 0.53773759 objValVar[1] - 0.93934427 objValVar[2]
   - 0.94031569 objValVar[3] - 0.3447028 objValVar[4]
   - 0.36092742 objValVar[5] - 0.62696254 objValVar[6]
   - 0.68824787 objValVar[7] - 0.34874709 objValVar[8]
   - 0.25989053 objValVar[9] - 0.19709851 objValVar[10] + [
   customerUtil[CustomerType2] ^2 ] <= 0
 customerUtilCalc[CustomerType3]: - 0.98918637 objValVar[0]
   - 0.9597768800000001 objValVar[1] - 0.30505229 objValVar[2]
   - 0.96212633 objValVar[3] - 0.09427434 objValVar[4]
   - 0.6756195 objValVar[5] - 0.52721584 objValVar[6]
   - 0.61422457 objValVar[7] - 0.71667116 objValVar[8]
   - 0.61611324 objValVar[9] - 0.86961674 objValVar[10] + [
   customerUtil[CustomerType3] ^2 ] <= 0
 marketShareCalc[CustomerType1]: - 9 marketShare[CustomerType1]
   + customerUtil[CustomerType1] + [
   - marketShare[CustomerType1] * customerUtil[CustomerType1] ] = 0
 marketShareCalc[CustomerType2]: - 8 marketShare[CustomerType2]
   + customerUtil[CustomerType2] + [
   - marketShare[CustomerType2] * customerUtil[CustomerType2] ] = 0
 marketShareCalc[CustomerType3]: - 8 marketShare[CustomerType3]
   + customerUtil[CustomerType3] + [
   - marketShare[CustomerType3] * customerUtil[CustomerType3] ] = 0
Bounds
 marketShare[CustomerType1] <= 1
 marketShare[CustomerType2] <= 1
 marketShare[CustomerType3] <= 1
 objValVar[0] <= 1
 objValVar[1] <= 1
 objValVar[2] <= 1
 objValVar[3] <= 1
 objValVar[4] <= 1
 objValVar[5] <= 1
 objValVar[6] <= 1
 objValVar[7] <= 1
 objValVar[8] <= 1
 objValVar[9] <= 1
 objValVar[10] <= 1
 sOut[1] <= 20
 sOut[2] <= 20
 sOut[3] <= 20
 sOut[4] <= 20
 sOut[5] <= 20
 sOut[6] = 0
 netTime[1] <= 38
 netTime[2] <= 38
 netTime[3] <= 38
 netTime[4] <= 38
 netTime[5] <= 38
 netTime[6] <= 38
Binaries
 nodeSelect[1] nodeSelect[2] nodeSelect[4] nodeSelect[5] arcSelect[1,3]
 arcSelect[1,6] arcSelect[2,3] arcSelect[2,6] arcSelect[3,6] arcSelect[4,6]
 arcSelect[5,6] optionSelect[1,0] optionSelect[1,1] optionSelect[2,0]
 optionSelect[2,1] optionSelect[3,0] optionSelect[3,1] optionSelect[4,0]
 optionSelect[4,1] optionSelect[5,0] optionSelect[5,1] optionSelect[6,0]
 optionSelect[6,1]
Generals
 stageTime[1] stageTime[2] stageTime[3] stageTime[4] stageTime[5]
 stageTime[6] stageCost[1] stageCost[2] stageCost[3] stageCost[4]
 stageCost[5] stageCost[6] sIn[1] sIn[2] sIn[3] sIn[4] sIn[5] sIn[6]
 sOut[1] sOut[2] sOut[3] sOut[4] sOut[5] sOut[6] netTime[1] netTime[2]
 netTime[3] netTime[4] netTime[5] netTime[6] sqRootnetTime[1]
 sqRootnetTime[2] sqRootnetTime[3] sqRootnetTime[4] sqRootnetTime[5]
 sqRootnetTime[6]
End

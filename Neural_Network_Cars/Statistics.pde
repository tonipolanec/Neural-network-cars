import org.gicentre.utils.stat.*; 
 
XYChart lineChart;
 

void updateStats(float[] generacije, float[] fitnessi){
  lineChart = new XYChart(this);
  lineChart.setYFormat("######"); 
  lineChart.setXFormat("##");   
  lineChart.setData(generacije, fitnessi);

  lineChart.setMinY(0);   
  lineChart.setMinX(0);
}
 

void showGraph()
{
    // Axis formatting and labels.
  lineChart.showXAxis(true); 
  lineChart.showYAxis(true); 
  
  // Symbol colours
  lineChart.setPointColour(0);
  lineChart.setPointSize(5);
  lineChart.setLineWidth(2);
  lineChart.setLineColour(0);
  lineChart.setAxisColour(0);
  lineChart.setAxisLabelColour(0);
  lineChart.setAxisValuesColour(0);
  textSize(12);
  lineChart.draw(-10,480,560,215);
}

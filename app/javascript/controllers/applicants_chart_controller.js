import ApplicationController from './application_controller'
import ApexCharts from "apexcharts"

export default class extends ApplicationController {
  static targets = ["chart"]

  static values = {
    categories: Array,
    series: Array
  }

  initialize() {
    this.chart = new ApexCharts(this.chartTarget, this.chartOptions);
    this.chart.render();
  }

  update() {
    console.log('applicants_chart_controller.js:18, event =>', event);
    this.stimulate('ApplicantsChart#update', event.target, { serializeForm: true })
  }
  
  afterUpdate() {
    this.chart.updateOptions({
      series: [{
        data: this.seriesValue
      }],
      xaxis: {
        categories: this.categoriesValue
      }
    });
  }

  get chartOptions() {
    return {
      chart: {
        height: "400px",
        type: 'line',
      },
      series: [{
        name: 'Applicants',
        data: this.seriesValue
      }],
      xaxis: {
        categories: this.categoriesValue,
        type: 'datetime'
      },
      stroke: {
        curve: "smooth"
      }
    }
  }
}

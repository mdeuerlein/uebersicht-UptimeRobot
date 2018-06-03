UPTIME_API_KEY = 'XXXX)'  # Your API Key
UPTIME_RATIO = '7'        # Days for ratio calculation

command: "curl -sS -X POST -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cache-Control: no-cache' -d 'api_key=#{ UPTIME_API_KEY }&format=json&custom_uptime_ratios=#{ UPTIME_RATIO }' 'https://api.uptimerobot.com/v2/getMonitors'"
refreshFrequency: 600000  # Milliseconds between calls


render: -> """
<div class="uptimerobot">
  <table>
    <thead>
      <tr>
        <th colspan=2>Monitor</th>
        <th>% Uptime</th>
      </tr>
    </thead><tbody></tbody></table>
  <style>
    @-webkit-keyframes blink {
       from { opacity: 1; }
       to { opacity: 0.2; }
    }
  </style>
</div>
"""

update: (output, domEl) ->
  response = JSON.parse(output)
  tbody = $(domEl).find('tbody')

  tbody.html('')

  renderStatus = (monitor) ->
    """
    <tr>
      <td class="monitor-status state#{ monitor.status }"><div class="disc"></div></td>
      <td class="monitor-name">#{ monitor.friendly_name }</td>
      <td class="uptime-ratio">#{ monitor.custom_uptime_ratio } %</td>
    </tr>
    """

  for monitor in response.monitors
    tbody.append renderStatus(monitor)


style: """
top: 50px
right: 40px
color: #ffffff
margin: 0 auto
font-family: Helvetica Neue, Sans-serif
font-smoothing: antialias
font-weight: 300
font-size: 16px
line-height: 27px


.uptimerobot
  background-color:rgba(0,0,0,0.5);
  padding:10px 20px;
  
th
  text-align:left;
  
.monitor-status
  padding: 0 9px 0 0

.uptime-ratio
  text-align:right

.disc
  width: 12px
  height: 12px
  border-radius: 50%

.state0 .disc
  background-color: rgba(145,145,145,1)

.state1 .disc
  background-color: rgba(192,192,192,1)

.state2 .disc
  background-color: rgba(0,240,0,0.6)

.state8 .disc
  background-color: rgba(255,147,0,1)
  animation: blink 2s cubic-bezier(0.950, 0.050, 0.795, 0.035) infinite alternate

.state9 .disc
  background-color: rgba(255,0,0,1)
  animation: blink .5s cubic-bezier(0.950, 0.050, 0.795, 0.035) infinite alternate

"""

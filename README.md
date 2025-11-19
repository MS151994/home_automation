# HomeAutomation

### Skrypt przygotowujący strukturę katalogów dla śwrodowiska automatyki domowej i jej monitoringu.
  #### Zawiera:
    - HomeAssistant - Core Automatyki domowej
    - MariaDB - Zewnętrzna baza danych
    - Portainer - Zarządzanie kontenerami
    - zigbee2mqtt - Proxy urządzeń zigbee
    - EMQX - Broker dla MQTT
    - ESPHome - Home Assistant add-on dla urządzeń DIY (ESP8266, ESP32)
    - MusicAssistant - Asystent muzyczny
    - Grafana - UI do monitoringu
    - Prometheus - System monitorowania
    - Loki - Logs scraper
    - Alloy - Monitorowanie kontenerów/systemu

## Pobieranie i uruchamianie pliku `pre_install.sh`

### Krok 1: Pobierz plik

Użyj poniższej komendy, aby pobrać skrypt i zapisać go w katalogu `/opt`:

```bash 
curl -o /opt/pre_install.sh https://raw.githubusercontent.com/MS151994/home_automation/main/script/pre_install.sh
```


### Krok 2: Ustaw uprawnienia do wykonywania

Nadaj plikowi prawa do uruchamiania:

```bash
sudo chmod +x /opt/pre_install.sh
```

### Krok 3: Uruchom skrypt

Aby uruchomić skrypt, wpisz:

```bash
sudo /opt/pre_install.sh $USER
```
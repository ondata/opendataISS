# Introduzione

L'**Istituto Superiore di Sanità** (ISS) ha [pubblicato](https://www.epicentro.iss.it/coronavirus/sars-cov-2-sorveglianza-dati) dal **21 agosto 2021** l'archivio dei dati che alimentano la *dashboard* denominata "[Dati della Sorveglianza integrata COVID-19 in Italia](https://www.epicentro.iss.it/coronavirus/sars-cov-2-dashboard)".

Queste le caratteristiche principali a quella data ([copia su *archive*](https://web.archive.org/web/20210821052235/https://www.epicentro.iss.it/coronavirus/sars-cov-2-sorveglianza-dati)) insieme a qualche nota:

- **due file** zip, uno per i dati del **2020** e uno per per quelli del **2021**;
- i dati sono archiviati in **formato** **`xlsx`**, uno per ogni giorno, quindi a quella data ci sono circa **480 file di dati**;
- ogni file è suddiviso in **11 fogli**, di cui 2 con metadati e 9 con i dati;
- ci sono due file con **nomi non coerenti** - `COVID_19_ISS_open_data_2021-02-04_corrected.xlsx` e `COVID_19_ISS_open_data_2021-08-04_old.xlsx` - che probabilmente andrebbero uno rinominato e uno rimosso;
- il formato **`xlsx`** **non è** nell'elenco dei **formati aperti** per i **dati**, presente nelle [**Linee guida nazionali per la valorizzazione del patrimonio informativo pubblico**](https://docs.italia.it/italia/daf/lg-patrimonio-pubblico/it/stabile/arch.html#formati-aperti-per-i-dati);
- non c'è una licenza associata, quindi vale la [licenza generale del sito](https://www.epicentro.iss.it/chi-siamo/disclaimer), che è una `CC BY-NC-SA 2.5`, quindi al momento **non sono open data**.

Scriveremo a ISS, per chiedere di utilizzare un **formato adeguato** alle già citate [Linee guida](https://docs.italia.it/italia/daf/lg-patrimonio-pubblico/it/stabile/arch.html#formati-aperti-per-i-dati) e agli *standard* internazionali e di **associare** a questi dati una **licenza** che li consenta di **classificare** **formalmente** e **usare** **sostanzialmente** come **open data**.

# Elaborazioni fatte

Al momento queste:

- **conversione formato** da `xlsx` a `csv`;
- **unione** di circa **4300 fogli di dati** (480 file x 9 fogli) in [**9 file**](data), uno per tipo (`casi_prelievo_diagnosi`, `casi_inizio_sintomi`, `casi_inizio_sintomi_sint`, `casi_regioni`, `casi_provincie`, `ricoveri`, `decessi`, `sesso_eta`, `stato_clinico`);
- **aggiunta** del **campo** `file` per dare conto del file `xlsx` di origine;
- **aggiunta** del **campo** `iss_date_iso8601`, che contiene il valore del campo `iss_date` convertito in formato `YYYY-MM-DD` (i.e. 2021-08-27);
- **aggiunta** del **campo** `file_date_iso8601`, che contiene la data formato `YYYY-MM-DD` (i.e. 2021-08-27) estratta dal nome del file `xlsx` sorgente. I singoli file hanno infatti questa struttura di nome `COVID_19_ISS_open_data_2020-05-14.xlsx`.

---

🙏Se vuoi sostenerci, puoi farlo con una [donazione](https://www.paypal.com/biz/fund?id=VCPYF6VDYX6EE&utm_campaign=Associazione%20onData%20newsletter&utm_medium=email&utm_source=Revue%20newsletter).

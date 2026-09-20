# Crystal Notes API

API JSON ligera para consultar y crear notas.

```powershell
crystal run notes.cr
curl http://localhost:8083/notes
curl -X POST http://localhost:8083/notes -H "Content-Type: application/json" -d '{"text":"Idea de producto"}'
```

/* Taken from http://superuser.com/a/536400 */
/* Use: cscript /nologo downloader.js <URL> */
/* Used by Windows batch scripts to download distro ISO image */

var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
WinHttpReq.Open("GET", WScript.Arguments(0), /*async=*/false);
WinHttpReq.Send();

BinStream = new ActiveXObject("ADODB.Stream");
BinStream.Type = 1;
BinStream.Open();
BinStream.Write(WinHttpReq.ResponseBody);
BinStream.SaveToFile("downloaded.bin");

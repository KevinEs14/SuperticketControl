part of 'api_client_rest.dart';

const bool _haveCert = true;

// const String _host = '192.168.0.10'; //LOCAL
//const String _host = '54.244.162.92'; //DEV
const String _host = 'api.superticket.live'; //PROD

const String _port = '';

const String baseUrl = _haveCert ? "https://$_host" : "http://$_host";
const String _urlBase = '${_host}:${_port}';

//
// URLS
//
const String authenticationUrl = "/api/authenticate";
const String accountUrl = '/api/account';
const String accessControlEventUrl = '/api/access/events';
const String accessControlUrl = '/api/access/access-controls';
const String accessTicketBookUrl = '/api/access/ticket-books';
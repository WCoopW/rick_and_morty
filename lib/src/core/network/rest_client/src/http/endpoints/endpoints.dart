/* -------------------------------------------------------------------------- */
/*                                  Endpoints                                 */
/* -------------------------------------------------------------------------- */
abstract class Endpoints {
/* -------------------------------------------------------------------------- */
  Duration _receiveTimeout = const Duration(milliseconds: 15000);
/* -------------------------------------------------------------------------- */
  Duration _connectionTimeout = const Duration(milliseconds: 30000);
/* -------------------------------------------------------------------------- */
  Duration _sendTimeout = const Duration(milliseconds: 15000);
/* -------------------------------------------------------------------------- */
  final String baseUrl;
/* -------------------------------------------------------------------------- */
  final String apiVersion;
/* -------------------------------------------------------------------------- */
  Duration get connectionTimeout => _connectionTimeout;
/* -------------------------------------------------------------------------- */
  Duration get receiveTimeout => _receiveTimeout;
/* -------------------------------------------------------------------------- */
  Duration get sendTimeout => _sendTimeout;
/* -------------------------------------------------------------------------- */
  set connectionTimeout(Duration duration) {
    assert(!duration.isNegative);
    _connectionTimeout = duration;
  }

/* -------------------------------------------------------------------------- */
  set receiveTimeout(Duration duration) {
    assert(!duration.isNegative);
    _receiveTimeout = duration;
  }

/* -------------------------------------------------------------------------- */
  set sendTimeout(Duration duration) {
    assert(!duration.isNegative);
    _sendTimeout = duration;
  }

/* -------------------------------------------------------------------------- */
  Endpoints({
    required this.baseUrl,
    required this.apiVersion,
    Duration? receiveTimeout,
    Duration? connectionTimeout,
    Duration? sendTimeout,
  })  : _receiveTimeout = receiveTimeout ?? const Duration(milliseconds: 15000),
        _connectionTimeout = connectionTimeout ?? const Duration(milliseconds: 30000),
        _sendTimeout = sendTimeout ?? const Duration(milliseconds: 15000);

/* -------------------------------------------------------------------------- */
  String buildEndpoint(String endpoint) {
    return '$baseUrl/$endpoint';
  }

/* -------------------------------------------------------------------------- */
  String buildApiEndpoint(String endpoint) {
    return buildEndpoint('$apiVersion/$endpoint');
  }

/* -------------------------------------------------------------------------- */
  String buildApiEndpointWithQuery(String endpoint, Map<String, dynamic>? queryParameters) {
    final baseEndpoint = buildApiEndpoint(endpoint);
    if (queryParameters == null || queryParameters.isEmpty) {
      return baseEndpoint;
    }

    final queryString = queryParameters.entries
        .where((entry) => entry.value != null)
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    return queryString.isNotEmpty ? '$baseEndpoint?$queryString' : baseEndpoint;
  }

/* -------------------------------------------------------------------------- */
  String buildEndpointWithQuery(String endpoint, Map<String, dynamic>? queryParameters) {
    final baseEndpoint = buildEndpoint(endpoint);
    if (queryParameters == null || queryParameters.isEmpty) {
      return baseEndpoint;
    }

    final queryString = queryParameters.entries
        .where((entry) => entry.value != null)
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    return queryString.isNotEmpty ? '$baseEndpoint?$queryString' : baseEndpoint;
  }
/* -------------------------------------------------------------------------- */
}

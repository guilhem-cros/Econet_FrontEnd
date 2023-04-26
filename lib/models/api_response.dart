/// Class containing an API response from any type of request
/// T is the type of object returned by the request
class APIResponse<T> {

  /// The data returned by the request, null if an error happened
  T? data;

  /// true if an error happened, false if not (false by default)
  bool error;

  /// The error message returned by the request, null if no error happened
  String? errorMessage;

  APIResponse({this.data, this.errorMessage, this.error=false});
}
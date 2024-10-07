class DataState<T> {
  final T? data;
  final String? errorMessage;
  final bool isLoading;

  DataState({
    this.data,
    this.errorMessage,
    this.isLoading = false,
  });

  factory DataState.loading() {
    return DataState(isLoading: true);
  }

  factory DataState.loaded(T data) {
    return DataState(data: data);
  }

  factory DataState.error(String message) {
    return DataState(errorMessage: message);
  }
}

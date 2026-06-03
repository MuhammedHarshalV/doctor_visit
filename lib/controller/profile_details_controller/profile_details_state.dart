import 'package:doctor_visit/model/profile/pro_profile_details_response_model.dart';

class ProfileDetailsState {
  final List<Detail> profileDetails;
  final bool isLoading;
  ProfileDetailsState({this.profileDetails = const [], this.isLoading = false});

  ProfileDetailsState copyWith({
    List<Detail>? profileDetails,
    bool? isLoading,
  }) {
    return ProfileDetailsState(
      profileDetails: profileDetails ?? this.profileDetails,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

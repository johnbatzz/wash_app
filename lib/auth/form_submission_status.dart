abstract class FormSubmissionStatus{
	const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
	const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {
	FormSubmitting();
}

class FacebookSubmitting extends FormSubmissionStatus {
	FacebookSubmitting();
}

class GoogleSubmitting extends FormSubmissionStatus {
	GoogleSubmitting();
}

class SubmissionSuccess extends FormSubmissionStatus {
	SubmissionSuccess();
}

class SubmissionFailed extends FormSubmissionStatus {
	final Exception exception;
	SubmissionFailed(this.exception);
}
# SmartReserve Application Test Plan

This document outlines the structured test scenarios for the SmartReserve application, covering core functionalities including authentication, booking management (Create, Edit, Delete), notifications, and slot exchange requests.

---

## 1. Authentication & Onboarding

| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **Login with Valid Credentials** | 1. Open App. <br> 2. Enter valid Email and Password. <br> 3. Click 'Login'. | User is successfully authenticated and navigated to the Main Dashboard. |
| **Login with Invalid Credentials** | 1. Enter incorrect Email/Password. <br> 2. Click 'Login'. | An error message "Check your Credentials" or "Invalid Email" is displayed. |
| **Password Recovery** | 1. Click 'Forget Password?' on Login screen. <br> 2. Enter a registered email. <br> 3. Submit request. | A password reset email is sent to the user's registered email address. |
| **Logout** | 1. Tap the three-dot menu in Main Screen. <br> 2. Select 'Logout'. | User is signed out and redirected to the Login screen. FCM topics are unsubscribed. |

---

## 2. Booking Management (CRUD)

### Create Booking
| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **Create New Booking** | 1. Click '+' button on Main Screen. <br> 2. Select a Date (up to 20 days ahead). <br> 3. Select a Hall (e.g., 2216-Hall). <br> 4. Choose available slots. <br> 5. Enter Course Code. <br> 6. Click 'Book Slot'. | User is navigated to a Verification screen, and the booking appears on the Main Screen list. |
| **Slot Occupancy Check** | 1. Attempt to book a slot that is already booked by another user. | The slot is displayed as occupied (different color/style) and cannot be selected for direct booking. |

### Filter & Read
| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **View Upcoming Bookings** | 1. Navigate to Main Screen. | A list of all upcoming and today's bookings for the current user is displayed. |
| **Filter by Hall** | 1. Click Filter icon on Main Screen. <br> 2. Select a specific Hall (e.g., Pheonix). | Only bookings belonging to the selected Hall are shown in the list. |
| **View Booking History** | 1. Open menu -> Select 'Previous Bookings'. | A list of all past bookings (older than today) is displayed. |

### Edit Booking
| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **Edit Upcoming Booking** | 1. On Main Screen list, click the 'Edit' (pencil) icon on a booking. <br> 2. Modify Course Code, Hall, or Slots. <br> 3. Save changes. | The booking is updated in the database and the changes reflect on the Main Screen. |
| **Edit Restriction (<15 mins)** | 1. Attempt to edit a booking that starts in less than 15 minutes. | An error "No slots available for editing (less than 15 mins remaining)" is shown. |

### Delete (Cancel) Booking
| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **Cancel Entire Booking** | 1. Click 'Delete' (trash) icon on a booking. <br> 2. Confirm if prompted (for single slot). | The booking is removed from the database and the UI list. |
| **Cancel Specific Slot** | 1. Click 'Delete' on a multi-slot booking. <br> 2. Select specific slots to cancel. <br> 3. Confirm. | Only the selected slots are removed; the rest of the booking remains. |
| **Cancel Restriction (<15 mins)** | 1. Attempt to cancel a slot starting in less than 15 minutes. | Cancellation is denied with an informative snackbar message. |

---

## 3. Slot Requests & Notifications

| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **View Slot Booker Info** | 1. In Booking Screen, tap an occupied slot. | A popup shows the name, Staff ID, and Course Code of the person who booked it. |
| **Request Occupied Slot** | 1. Tap an occupied slot (not yours). <br> 2. Tap 'Request'. <br> 3. Enter your Course Code and submit. | A notification request is sent to the original booker. |
| **Receive Notification** | 1. Tap Notification bell on Main Screen. | A list of requests from other users is displayed with 'Accept'/'Reject' options. |
| **Accept Slot Request** | 1. Tap 'Accept' on a pending notification. | The booking is transferred to the requester, and the original booker's slot is removed. |
| **Reject Slot Request** | 1. Tap 'Reject' on a pending notification. | The request is marked as rejected, and no changes are made to the booking. |

---

## 4. General UI & Information

| Test Scenario | Steps | Expected Result |
| :--- | :--- | :--- |
| **App Branding & About** | 1. Tap 'i' (info) icon on Main Screen. | The About Screen is displayed with application details and developer information. |
| **Responsive Layout** | 1. Navigate through screens in different orientations (if supported). | The UI elements (Frosted Glass, Background Shapes) scale and render correctly. |
| **Notification Badge** | 1. Receive a new slot request while on Main Screen. | The notification bell icon shows a red badge with the count of pending requests. |

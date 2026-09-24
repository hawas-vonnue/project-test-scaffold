-- CreateEnum
CREATE TYPE "SubmissionStatus" AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED');

-- CreateEnum
CREATE TYPE "FlagEventType" AS ENUM ('FULLSCREEN_EXIT', 'TAB_SWITCH', 'PASTE_BLOCKED', 'UNAUTHORIZED_ACCESS_ATTEMPT');

-- CreateTable
CREATE TABLE "trainee" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "trainee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "curriculum_day" (
    "id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "day_number" INTEGER NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "curriculum_day_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "task" (
    "id" UUID NOT NULL,
    "curriculum_day_id" UUID NOT NULL,
    "sequence_order" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "instructions_markdown" TEXT NOT NULL,
    "is_stretch_goal" BOOLEAN NOT NULL DEFAULT false,
    "time_permitted" INTEGER,

    CONSTRAINT "task_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "submission" (
    "id" UUID NOT NULL,
    "trainee_id" UUID NOT NULL,
    "task_id" UUID NOT NULL,
    "status" "SubmissionStatus" NOT NULL DEFAULT 'NOT_STARTED',
    "file_contents" JSONB NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "submission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "activity_log" (
    "id" UUID NOT NULL,
    "trainee_id" UUID NOT NULL,
    "curriculum_day_id" UUID,
    "date" DATE NOT NULL,
    "active_seconds" INTEGER NOT NULL DEFAULT 0,
    "coding_seconds" INTEGER NOT NULL DEFAULT 0,
    "reading_seconds" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "activity_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flag_event" (
    "id" UUID NOT NULL,
    "trainee_id" UUID NOT NULL,
    "task_id" UUID,
    "type" "FlagEventType" NOT NULL,
    "review_priority" INTEGER NOT NULL DEFAULT 0,
    "context_data" JSONB,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "flag_event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "typing_test_result" (
    "id" UUID NOT NULL,
    "trainee_id" UUID NOT NULL,
    "wpm" DECIMAL(5,2) NOT NULL,
    "accuracy" DECIMAL(5,2) NOT NULL,
    "taken_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "typing_test_result_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "journal_response" (
    "id" UUID NOT NULL,
    "trainee_id" UUID NOT NULL,
    "curriculum_day_id" UUID NOT NULL,
    "response_text" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "journal_response_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "day_unlock" (
    "id" UUID NOT NULL,
    "trainee_id" UUID NOT NULL,
    "curriculum_day_id" UUID NOT NULL,
    "unlocked" BOOLEAN NOT NULL DEFAULT false,
    "is_completed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "day_unlock_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "trainee_email_key" ON "trainee"("email");

-- CreateIndex
CREATE UNIQUE INDEX "curriculum_day_course_id_day_number_key" ON "curriculum_day"("course_id", "day_number");

-- CreateIndex
CREATE UNIQUE INDEX "task_curriculum_day_id_sequence_order_key" ON "task"("curriculum_day_id", "sequence_order");

-- CreateIndex
CREATE UNIQUE INDEX "submission_trainee_id_task_id_key" ON "submission"("trainee_id", "task_id");

-- CreateIndex
CREATE UNIQUE INDEX "activity_log_trainee_id_date_key" ON "activity_log"("trainee_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "journal_response_trainee_id_curriculum_day_id_key" ON "journal_response"("trainee_id", "curriculum_day_id");

-- CreateIndex
CREATE UNIQUE INDEX "day_unlock_trainee_id_curriculum_day_id_key" ON "day_unlock"("trainee_id", "curriculum_day_id");

-- AddForeignKey
ALTER TABLE "curriculum_day" ADD CONSTRAINT "curriculum_day_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "task" ADD CONSTRAINT "task_curriculum_day_id_fkey" FOREIGN KEY ("curriculum_day_id") REFERENCES "curriculum_day"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission" ADD CONSTRAINT "submission_trainee_id_fkey" FOREIGN KEY ("trainee_id") REFERENCES "trainee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission" ADD CONSTRAINT "submission_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "task"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_log" ADD CONSTRAINT "activity_log_trainee_id_fkey" FOREIGN KEY ("trainee_id") REFERENCES "trainee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_log" ADD CONSTRAINT "activity_log_curriculum_day_id_fkey" FOREIGN KEY ("curriculum_day_id") REFERENCES "curriculum_day"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flag_event" ADD CONSTRAINT "flag_event_trainee_id_fkey" FOREIGN KEY ("trainee_id") REFERENCES "trainee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flag_event" ADD CONSTRAINT "flag_event_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "task"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "typing_test_result" ADD CONSTRAINT "typing_test_result_trainee_id_fkey" FOREIGN KEY ("trainee_id") REFERENCES "trainee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "journal_response" ADD CONSTRAINT "journal_response_trainee_id_fkey" FOREIGN KEY ("trainee_id") REFERENCES "trainee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "journal_response" ADD CONSTRAINT "journal_response_curriculum_day_id_fkey" FOREIGN KEY ("curriculum_day_id") REFERENCES "curriculum_day"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "day_unlock" ADD CONSTRAINT "day_unlock_trainee_id_fkey" FOREIGN KEY ("trainee_id") REFERENCES "trainee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "day_unlock" ADD CONSTRAINT "day_unlock_curriculum_day_id_fkey" FOREIGN KEY ("curriculum_day_id") REFERENCES "curriculum_day"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
